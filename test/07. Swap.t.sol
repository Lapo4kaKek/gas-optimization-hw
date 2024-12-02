// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import "../lib/forge-std/src/Test.sol";
import "src/07. Swap.sol";

// forge test --match-contract Swap
// forge test --match-contract Swap --gas-report
contract SwapTest is Test {
    Swap swap;

    function setUp() public {
        swap = new Swap();
    }

    function test_swap() public view {
        (uint256 a, uint256 b) = swap.swap(300, 200);
        assertEq(a, 200);
        assertEq(b, 300);
    }
}

contract SwapOptimizedTest is Test {
    SwapOptimized swap;

    function setUp() public {
        swap = new SwapOptimized();
    }

    function test_swap() public view {
        (uint256 a, uint256 b) = swap.swap(300, 200);
        assertEq(a, 200);
        assertEq(b, 300);
    }
}
