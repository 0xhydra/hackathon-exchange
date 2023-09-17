// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import { WRAP_NATIVE } from "src/constants/AddressConstants.sol";

contract WrappedNativeReceiver {
    /**
     * @dev only accept WKLAY via fallback from the WKLAY contract
     */

    receive() external payable {
        assert(msg.sender == WRAP_NATIVE);
    }
}
