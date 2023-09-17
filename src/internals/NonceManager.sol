// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import { BitMaps } from "src/libraries/BitMaps.sol";

/**
 * @title NonceManager
 * @notice Protocol fee management
 */
contract NonceManager {
    using BitMaps for BitMaps.BitMap;

    error NonceManager__InvalidNonce();

    event CancelAllOrders(address indexed user, uint256 newMinNonce);
    event CancelMultipleOrders(address indexed user, uint256[] orderNonces);

    mapping(address => uint256) internal _minNonce;
    mapping(address => BitMaps.BitMap) internal _isNonceExecutedOrCancelled;

    /**
     * @notice Check whether user order nonce is executed or cancelled
     * @param account address of user
     * @param nonce nonce of the order
     */
    function isNonceExecutedOrCancelled(address account, uint256 nonce) external view returns (bool) {
        return _isUsed(account, nonce);
    }

    /**
     * @notice Cancel all pending orders for a sender
     * @param minNonce_ minimum user nonce
     */
    function cancelAllOrders(uint256 minNonce_) external {
        bytes32 nonceKey;
        uint256 nonce;
        assembly {
            mstore(0, caller())
            mstore(32, _minNonce.slot)
            nonceKey := keccak256(0, 64)
            nonce := sload(nonceKey)
        }

        if (minNonce_ <= nonce || minNonce_ >= nonce + 10_000) revert NonceManager__InvalidNonce();

        assembly {
            sstore(nonceKey, minNonce_)
        }

        emit CancelAllOrders(msg.sender, minNonce_);
    }

    /**
     * @notice Cancel maker orders
     * @param nonces_ array of order nonces
     */
    function cancelSellOrders(uint256[] calldata nonces_) external {
        uint256 length = nonces_.length;

        if (length == 0) return;

        address sender = msg.sender;

        uint256 minNonce = _minNonce[sender]; // cache storage to memory
        BitMaps.BitMap storage map = _isNonceExecutedOrCancelled[sender];

        for (uint256 i; i < length;) {
            if (nonces_[i] < minNonce) revert NonceManager__InvalidNonce();

            map.set(nonces_[i]);
            unchecked {
                ++i;
            }
        }

        emit CancelMultipleOrders(sender, nonces_);
    }

    function _setUsed(address account, uint256 nonce) internal {
        _isNonceExecutedOrCancelled[account].set(nonce);
    }

    function _isUsed(address account, uint256 nonce) internal view returns (bool) {
        return _isNonceExecutedOrCancelled[account].get(nonce);
    }
}
