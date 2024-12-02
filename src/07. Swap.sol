// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import "./Interfaces.sol";

contract Swap is ISwap {
    function swap(uint256 a, uint256 b) public pure returns (uint256, uint256) {
        a = a + b;
        b = a - b;
        a = a - b;
        return (a, b);
    }
}

contract SwapOptimized is ISwap {
    function swap(uint256 a, uint256 b) public pure returns (uint256, uint256) {
        a = a ^ b;
        b = a ^ b;
        a = a ^ b;
        return (a, b);
    }
}
