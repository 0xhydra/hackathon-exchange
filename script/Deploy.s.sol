// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.19;

import { FireFlyExchange } from "src/FireFlyExchange.sol";

import { BaseScript } from "./Base.s.sol";

/// @dev See the Solidity Scripting tutorial: https://book.getfoundry.sh/tutorials/solidity-scripting
contract Deploy is BaseScript {
    address public registry = 0x02101dfB77FDE026414827Fdc604ddAF224F0921;
    address public implementation = address(0x2298edBc3ccF222B579FECd4E2fd701B88f1E56D);
    string public name = "FireflyExchange";
    string public version = "1";

    function run() public broadcast returns (FireFlyExchange firefly) {
        firefly = new FireFlyExchange(name, version, registry, implementation);
    }
}
