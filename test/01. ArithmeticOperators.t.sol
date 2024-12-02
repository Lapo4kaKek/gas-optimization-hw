// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import "../lib/forge-std/src/Test.sol";
import "src/01. ArithmeticOperators.sol";

// forge test --match-contract ArithmeticOperators
// forge test --match-contract ArithmeticOperators --gas-report
contract ArithmeticOperatorsTest is Test {
    Addition addition;
    Subtraction subtraction;
    Division division;

    function setUp() public {
        addition = new Addition();
        subtraction = new Subtraction();
        division = new Division();
    }

    function test_Addition() public {
        addition.addition(10);
    }

    function test_Subtraction() public {
        subtraction.subtraction(10);
    }

    function test_DivisionBy2() public view {
        division.divisionBy2(1024);
    }

    function test_DivisionBy128() public view {
        division.divisionBy128(1024);
    }
}

contract ArithmeticOperatorsOptimizedTest is Test {
    AdditionOptimized additionOptimized;
    SubtractionOptimized subtractionOptimized;
    DivisionOptimized divisionOptimized;

    function setUp() public {
        additionOptimized = new AdditionOptimized();
        subtractionOptimized = new SubtractionOptimized();
        divisionOptimized = new DivisionOptimized();
    }

    function test_AdditionOptimized() public {
    additionOptimized.addition(10);
}

function test_SubtractionOptimized() public {
    subtractionOptimized.subtraction(10);
}



    function test_DivisionBy2Optimized() public {
        uint256 result = divisionOptimized.divisionBy2(1024);
    }

    function test_DivisionBy128Optimized() public {
        uint256 result = divisionOptimized.divisionBy128(1024);
    }
}
