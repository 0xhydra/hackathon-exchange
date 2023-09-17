// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

interface IWKLAY {
    function deposit() external payable;

    function withdraw(uint256 wad) external;
}
