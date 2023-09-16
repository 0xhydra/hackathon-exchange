// SPDX-License-Identifier: MIT

pragma solidity 0.8.19;

// External
import { AccessControl } from "@openzeppelin/contracts/access/AccessControl.sol";
import { ECDSA } from "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import { EIP712 } from "@openzeppelin/contracts/utils/cryptography/EIP712.sol";
import { ReentrancyGuard } from "@openzeppelin/contracts/security/ReentrancyGuard.sol";

// Internal
import { CurrencyManager } from "src/internals/CurrencyManager.sol";
import { FeeManager } from "src/internals/FeeManager.sol";

// Interfaces
import { IFireFlyExchange } from "src/interfaces/IFireFlyExchange.sol";

// Libraries
import { OrderStructs } from "src/libraries/OrderStructs.sol";
import { BitMaps } from "src/libraries/BitMaps.sol";

// Enums
import { QuoteType } from "src/enums/QuoteType.sol";

// Constants
import { NATIVE_TOKEN } from "src/constants/AddressConstants.sol";
import { OPERATOR_ROLE, CURRENCY_ROLE, COLLECTION_ROLE } from "src/constants/RoleConstants.sol";

contract FireFlyExchange is IFireFlyExchange, AccessControl, CurrencyManager, EIP712, FeeManager, ReentrancyGuard {
    using BitMaps for BitMaps.BitMap;
    using OrderStructs for OrderStructs.Maker;

    mapping(address => uint256) private _minNonce;
    mapping(address => BitMaps.BitMap) private _isNonceExecutedOrCancelled;

    /**
     * @notice Constructor
     */
    constructor(string memory name_) EIP712(name_, "1") {
        address sender = _msgSender();
        bytes32 operatorRole = OPERATOR_ROLE;
        bytes32 currencyRole = CURRENCY_ROLE;
        bytes32 collectionRole = COLLECTION_ROLE;

        _grantRole(DEFAULT_ADMIN_ROLE, sender);
        _grantRole(operatorRole, sender);
        _grantRole(currencyRole, address(0));

        _setRoleAdmin(currencyRole, operatorRole);
        _setRoleAdmin(collectionRole, operatorRole);
    }

    /**
     * @inheritdoc IFireFlyExchange
     */
    function executeMakerAsk(
        OrderStructs.Taker calldata takerBid,
        OrderStructs.Maker calldata makerAsk,
        bytes calldata makerSignature
    )
        external
        payable
        nonReentrant
    {
        bytes32 makerHash = makerAsk.hash();

        // Check the maker ask order
        _validateOrder(makerAsk, makerHash, makerSignature);

        // prevents replay
        _isNonceExecutedOrCancelled[makerAsk.signer].set(makerAsk.orderNonce);

        address buyer = takerBid.recipient;

        // Execute transfer currency
        _transferFeesAndFunds(makerAsk.currency, buyer, makerAsk.signer, makerAsk.price);

        // Execute transfer token collection
        _transferNonFungibleToken(makerAsk.collection, makerAsk.signer, buyer, makerAsk.tokenId);
    }

    /**
     * @inheritdoc IFireFlyExchange
     */
    function executeMakerBid(
        OrderStructs.Taker calldata takerAsk,
        OrderStructs.Maker calldata makerBid,
        bytes calldata makerSignature
    )
        external
        payable
        nonReentrant
    { }

    /**
     * @notice Transfer fees and funds to protocol recipient, and seller
     * @param currency_ currency being used for the purchase (e.g., WETH/USDC)
     * @param from_ sender of the funds
     * @param to_ seller's recipient
     * @param amount_ amount being transferred (in currency)
     */
    function _transferFeesAndFunds(address currency_, address from_, address to_, uint256 amount_) internal {
        if (currency_ == NATIVE_TOKEN) _receiveNative(amount_);

        // Initialize the final amount that is transferred to seller
        uint256 finalSellerAmount = amount_;

        // 1. Protocol fee

        // 2. Transfer final amount (post-fees) to seller
        {
            _transferCurrency(currency_, from_, to_, finalSellerAmount);
        }
    }

    /**
     * @notice Verify the validity of the maker order
     * @param makerAsk maker ask
     */
    function _validateOrder(
        OrderStructs.Maker calldata makerAsk,
        bytes32 makerHash,
        bytes calldata makerSignature
    )
        private
        view
    {
        // Verify the price is not 0
        if (makerAsk.price == 0) revert Exchange__ZeroValue();

        // Verify order timestamp
        if (makerAsk.startTime > block.timestamp || makerAsk.endTime < block.timestamp) {
            revert Exchange__OutOfRange();
        }

        // Verify whether the currency is whitelisted
        if (!hasRole(CURRENCY_ROLE, makerAsk.currency)) revert Exchange__InvalidCurrency();
        if (!hasRole(COLLECTION_ROLE, makerAsk.collection)) revert Exchange__InvalidCollection();

        (address recoveredAddress,) = ECDSA.tryRecover(_hashTypedDataV4(makerHash), makerSignature);

        // Verify the validity of the signature
        if (recoveredAddress == address(0) || recoveredAddress != makerAsk.signer) {
            revert Exchange__InvalidSigner();
        }

        // Verify whether order nonce has expired
        if (
            makerAsk.orderNonce < _minNonce[makerAsk.signer]
                || _isNonceExecutedOrCancelled[makerAsk.signer].get(makerAsk.orderNonce)
        ) revert Exchange__InvalidNonce();
    }
}
