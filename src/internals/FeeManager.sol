// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

/**
 * @title FeeManager
 * @notice Protocol fee management
 */
contract FeeManager {
    // Event if the protocol fee changes
    event NewProtocolFee(address protocolRecipient, uint256 protocolFee);

    // Protocol fee
    uint256 internal _protocolFee;
    address internal _protocolFeeRecipient;

    function _setProtocolFee(address newProtocolFeeRecipient_, uint256 newProtocolFee_) internal {
        _protocolFeeRecipient = newProtocolFeeRecipient_;
        _protocolFee = newProtocolFee_;

        emit NewProtocolFee(newProtocolFeeRecipient_, newProtocolFee_);
    }

    /**
     * @notice Return protocol fee for this strategy
     * @return protocol fee
     */
    function viewProtocolFeeInfo() external view returns (address, uint256) {
        return (_protocolFeeRecipient, _protocolFee);
    }
}
