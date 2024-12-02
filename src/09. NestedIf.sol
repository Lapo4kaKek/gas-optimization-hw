// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import "./Interfaces.sol";

contract NestedIf is INestedIf {
    function call(uint256 number) public pure returns (bool) {
        if (number > 0 && number != 50 && number < 100) {
            return true;
        }
        return false;
    }
}

contract NestedIfOptimized is INestedIf {
    function call(uint256 number) external pure returns (bool) {
        return number > 0 && number < 100 && number != 50;
    }
}

