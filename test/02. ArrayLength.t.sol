// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import "../lib/forge-std/src/Test.sol";
import "src/02. ArrayLength.sol";

// forge test --match-contract ArrayLength
// forge test --match-contract ArrayLength --gas-report
contract ArrayLengthsTest is Test {
    ArrayLength arrayLength;

    function setUp() public {
        arrayLength = new ArrayLength();
    }

    function test_Call() public view {
        arrayLength.callFor();
    }
}

contract ArrayLengthsOptimizedTest is Test {
    ArrayLengthOptimized arrayLength;

    function setUp() public {
        arrayLength = new ArrayLengthOptimized();
    }

    function test_Call() public view {
        arrayLength.callFor();
    }
}