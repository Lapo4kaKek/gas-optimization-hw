// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import "./Interfaces.sol";

contract CalldataMemory is ICalldataMemory {
    function add(uint256[] memory myArray) external pure returns (uint256 sum) {
        uint256 length = myArray.length;
        for (uint256 i; i < length; i++) {
            sum += myArray[i];
        }
    }
}

contract CalldataMemoryOptimized is ICalldataMemory {
    function add(uint256[] memory myArray) external pure returns (uint256 sum) {
        uint256 length = myArray.length;
        for (uint256 i; i < length; i++) {
            uint256 item = myArray[i];
            unchecked {
                sum += item;
            }
        }
    }
}
