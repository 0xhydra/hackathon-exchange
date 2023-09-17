// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import { AccessControl } from "@openzeppelin/contracts/access/AccessControl.sol";
import { OPERATOR_ROLE } from "src/constants/RoleConstants.sol";
import { IERC6551Registry } from "erc6551/src/interfaces/IERC6551Registry.sol";

contract AccountRegistry is AccessControl {
    IERC6551Registry internal _registry;
    address internal _implementation;

    constructor(address registry_, address implementation_) {
        _setRegistryInfo(IERC6551Registry(registry_), implementation_);
    }

    function _setRegistryInfo(IERC6551Registry registry_, address implementation_) internal {
        _registry = registry_;
        _implementation = implementation_;
    }

    function setRegistryInfo(IERC6551Registry registry_, address implementation_) external onlyRole(OPERATOR_ROLE) {
        _setRegistryInfo(registry_, implementation_);
    }
}
