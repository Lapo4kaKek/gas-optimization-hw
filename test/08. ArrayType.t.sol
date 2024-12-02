// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import "../lib/forge-std/src/Test.sol";
import "src/08. ArrayType.sol";

// forge test --match-contract ArrayType
// forge test --match-contract ArrayType --gas-report
contract ArrayTypeTest is Test {
    ArrayType array;

    function setUp() public {
        array = new ArrayType();
    }

    function test_init() public {
        array.initArray();
    }
}

contract ArrayTypeOptimizedTest is Test {
    ArrayTypeOptimized array;

    function setUp() public {
        array = new ArrayTypeOptimized();
    }

    function test_init() public {
        array.initArray();
    }
}
