// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import { IERC721 } from "@openzeppelin/contracts/token/ERC721/IERC721.sol";

import { NATIVE_TOKEN } from "src/constants/AddressConstants.sol";

import { SafeTransfer } from "src/libraries/SafeTransfer.sol";
import { ErrorHandler } from "src/libraries/ErrorHandler.sol";

contract CurrencyManager {
    error NotReceivedERC721();

    using ErrorHandler for bool;

    /**
     * @notice Transfer NFT
     * @param collection_ address of the token collection
     * @param from_ address of the sender
     * @param to_ address of the recipient
     * @param tokenId_ tokenId
     */
    function _transferNonFungibleToken(address collection_, address from_, address to_, uint256 tokenId_) internal {
        SafeTransfer.safeTransferFrom(collection_, from_, to_, tokenId_);
        if (_safeOwnerOf(collection_, tokenId_) != to_) revert NotReceivedERC721();
    }

    /// @dev Transfers a given amount of currency.
    function _receiveNative(uint256 amount_) internal {
        uint256 refund = msg.value - amount_; // throw error if msg.value < amount
        if (refund == 0) return;
        SafeTransfer.safeTransferETH(msg.sender, amount_);
    }

    /// @dev Transfers a given amount of currency.
    function _transferCurrency(address currency_, address from_, address to_, uint256 amount_) internal {
        if (amount_ == 0) return;
        if (from_ == to_) return;

        if (currency_ == NATIVE_TOKEN) {
            SafeTransfer.safeTransferETH(to_, amount_);
        } else {
            _safeTransferERC20(currency_, from_, to_, amount_);
        }
    }

    /// @dev Transfer `amount` of ERC20 token from `from` to `to`.
    function _safeTransferERC20(address currency_, address from_, address to_, uint256 amount_) internal {
        if (from_ == to_) return;

        if (from_ == address(this)) {
            SafeTransfer.safeTransfer(currency_, to_, amount_);
        } else {
            SafeTransfer.safeTransferFrom(currency_, from_, to_, amount_);
        }
    }

    function _safeOwnerOf(address token_, uint256 tokenId_) internal view returns (address owner) {
        (bool success, bytes memory data) = token_.staticcall(abi.encodeCall(IERC721.ownerOf, (tokenId_)));
        if (success) {
            return abi.decode(data, (address));
        }
        success.handleRevertIfNotSuccess(data);
    }
}
