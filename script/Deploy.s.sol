// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.19;

import { FireFlyExchange } from "src/FireFlyExchange.sol";

import { BaseScript } from "./Base.s.sol";

/// @dev See the Solidity Scripting tutorial: https://book.getfoundry.sh/tutorials/solidity-scripting
contract Deploy is BaseScript {
    function run() public broadcast returns (FireFlyExchange firefly) {
        firefly = new FireFlyExchange("FireflyExchange");
    }
}
