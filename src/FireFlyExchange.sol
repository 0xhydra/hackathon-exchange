// SPDX-License-Identifier: MIT

pragma solidity 0.8.19;

// External
import { AccessControl } from "@openzeppelin/contracts/access/AccessControl.sol";
import { ECDSA } from "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import { EIP712 } from "@openzeppelin/contracts/utils/cryptography/EIP712.sol";
import { ReentrancyGuard } from "@openzeppelin/contracts/security/ReentrancyGuard.sol";

// Interfaces
import { IFireFlyExchange } from "src/interfaces/IFireFlyExchange.sol";

// Libraries
import { OrderStructs } from "src/libraries/OrderStructs.sol";
import { BitMaps } from "src/libraries/BitMaps.sol";

// Enums
import { QuoteType } from "src/enums/QuoteType.sol";

contract FireFlyExchange is IFireFlyExchange, AccessControl, ReentrancyGuard, EIP712 {
    using BitMaps for BitMaps.BitMap;
    using OrderStructs for OrderStructs.Maker;

    mapping(address => uint256) private _minNonce;
    mapping(address => BitMaps.BitMap) private _isNonceExecutedOrCancelled;

    /**
     * @notice Constructor
     */
    constructor(string memory name_) EIP712(name_, "1") { }

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
    { }
}
