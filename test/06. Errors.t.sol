// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import "../lib/forge-std/src/Test.sol";
import "src/06. Errors.sol";

// forge test --match-contract Errors
// forge test --match-contract Errors --gas-report
contract ErrorsTest is Test {
    Errors errors;

    function setUp() public {
        errors = new Errors();
    }

    function test_call() public {
        vm.startPrank(address(0x01));
        vm.expectRevert();
        errors.call();
        vm.stopPrank();
    }
}

contract ErrorsOptimizedTest is Test {
    ErrorsOptimized errors;

    function setUp() public {
        errors = new ErrorsOptimized();
    }

    function test_call() public {
        vm.startPrank(address(0x01));
        vm.expectRevert();
        errors.call();
        vm.stopPrank();
    }
}