// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import { BitMaps } from "src/libraries/BitMaps.sol";

/**
 * @title NonceManager
 * @notice Protocol fee management
 */
contract NonceManager {
    using BitMaps for BitMaps.BitMap;

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

    function _setUsed(address account, uint256 nonce) internal {
        _isNonceExecutedOrCancelled[account].set(nonce);
    }

    function _isUsed(address account, uint256 nonce) internal view returns (bool) {
        return _isNonceExecutedOrCancelled[account].get(nonce);
    }
}
