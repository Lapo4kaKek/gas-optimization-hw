// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import "../lib/forge-std/src/Test.sol";
import "src/10. MultiSigWallet.sol";


// forge test --match-contract MultiSigWallet
// forge test --match-contract MultiSigWallet --gas-report
contract MultiSigWalletTest is Test {
    MultiSigWallet wallet;
    address[] owners;
    uint256 required;

    address owner1 = address(0x1);
    address owner2 = address(0x2);
    address owner3 = address(0x3);

    function setUp() public {
        owners = [owner1, owner2, owner3];
        required = 2;

        wallet = new MultiSigWallet(owners, required);

        payable(address(wallet)).transfer(1 ether);
    }

    function testInitialization() public view {
        assertEq(wallet.owners(0), owner1);
        assertEq(wallet.owners(1), owner2);
        assertEq(wallet.owners(2), owner3);
        assertEq(wallet.required(), required);
    }

    function testSubmitTransaction() public {
        vm.startPrank(owner1);
        wallet.submitTransaction(address(0x4), 100);
        assertEq(wallet.getTransactionCount(), 1);

        (
            uint256 transactionID,
            address destination,
            uint256 value,
            uint256 confirmationCount,
            uint256 executionTimestamp,
            bool executed
        ) = wallet.transactions(0);

        assertEq(transactionID, 0);
        assertEq(destination, address(0x4));
        assertEq(value, 100);
        assertEq(confirmationCount, 0);
        assertEq(executionTimestamp, 0);
        assertEq(executed, false);
        vm.stopPrank();
    }

    function testConfirmTransaction() public {
        vm.startPrank(owner1);
        wallet.submitTransaction(address(0x4), 100);

        wallet.confirmTransaction(0);
        address[] memory confirmations = wallet.getConfirmations(0);
        assertEq(confirmations.length, 1);
        assertEq(confirmations[0], owner1);

        (,,, uint256 confirmationCount,,) = wallet.transactions(0);
        assertEq(confirmationCount, 1);
        vm.stopPrank();
    }

    function testExecuteTransaction() public {
        vm.startPrank(owner1);
        wallet.submitTransaction(address(0x4), 100);

        wallet.confirmTransaction(0);
        vm.stopPrank();

        vm.prank(owner2);
        wallet.confirmTransaction(0);

        (,,,,, bool executed) = wallet.transactions(0);
        assertTrue(executed);
    }

    function testExecutionFailure() public {
        vm.startPrank(owner1);
        wallet.submitTransaction(address(0x4), 100 ether);

        wallet.confirmTransaction(0);
        vm.stopPrank();

        vm.prank(owner2);
        wallet.confirmTransaction(0);

        (,,,,, bool executed) = wallet.transactions(0);
        assertFalse(executed);
    }

    function testOnlyOwnerCanSubmit() public {
        vm.prank(address(0x5));
        vm.expectRevert("Not owner");
        wallet.submitTransaction(address(0x4), 100);
    }

    function testOnlyOwnerCanConfirm() public {
        vm.prank(owner1);
        wallet.submitTransaction(address(0x4), 100);

        vm.prank(address(0x5));
        vm.expectRevert("Not owner");
        wallet.confirmTransaction(0);
    }

    function testOnlyOwnerCanExecute() public {
        vm.startPrank(owner1);
        wallet.submitTransaction(address(0x4), 100);

        wallet.confirmTransaction(0);
        vm.stopPrank();

        vm.prank(owner2);
        wallet.confirmTransaction(0);

        vm.prank(address(0x5));
        vm.expectRevert("Not owner");
        wallet.executeTransaction(0);
    }
}



contract MultiSigWalletOptimizedTest is Test {
    MultiSigWalletOptimized wallet;
    address[] owners;
    uint256 required;

    address owner1 = address(0x1);
    address owner2 = address(0x2);
    address owner3 = address(0x3);
    address nonOwner = address(0x4);

    function setUp() public {
        owners = [owner1, owner2, owner3];
        required = 2;

        wallet = new MultiSigWalletOptimized(owners, required);

        vm.deal(address(wallet), 1 ether);
    }

    function testInitialization() public {
        assertTrue(wallet.isOwner(owner1));
        assertTrue(wallet.isOwner(owner2));
        assertTrue(wallet.isOwner(owner3));
        assertFalse(wallet.isOwner(nonOwner));
        assertEq(wallet.required(), required);
    }

    function testSubmitTransaction() public {
        vm.startPrank(owner1);
        wallet.submitTransaction(address(0x5), 100);

        assertEq(wallet.getTransactionCount(), 1);

        (
            address destination,
            uint256 value,
            uint256 confirmationCount,
            bool executed
        ) = wallet.getTransaction(0);

        assertEq(destination, address(0x5));
        assertEq(value, 100);
        assertEq(confirmationCount, 0);
        assertFalse(executed);

        vm.stopPrank();
    }

    function testConfirmTransaction() public {
        vm.startPrank(owner1);
        wallet.submitTransaction(address(0x5), 100);

        wallet.confirmTransaction(0);

        assertTrue(wallet.confirmations(0, owner1));
        (, , uint256 confirmationCount, ) = wallet.getTransaction(0);
        assertEq(confirmationCount, 1);

        vm.stopPrank();
    }

    function testExecuteTransaction() public {
        vm.startPrank(owner1);
        wallet.submitTransaction(address(0x5), 100);

        wallet.confirmTransaction(0);
        vm.stopPrank();

        vm.prank(owner2);
        wallet.confirmTransaction(0);

        (, , , bool executed) = wallet.getTransaction(0);
        assertTrue(executed);
    }

    function testExecutionFailure() public {
        vm.startPrank(owner1);
        wallet.submitTransaction(address(0x5), 2 ether); // Недостаточно средств

        wallet.confirmTransaction(0);
        vm.stopPrank();

        vm.prank(owner2);
        wallet.confirmTransaction(0);

        (, , , bool executed) = wallet.getTransaction(0);
        assertFalse(executed); // Выполнение должно было провалиться
    }

    function testOnlyOwnerCanSubmit() public {
        vm.prank(nonOwner);
        vm.expectRevert("Not owner");
        wallet.submitTransaction(address(0x5), 100);
    }

    function testOnlyOwnerCanConfirm() public {
        vm.startPrank(owner1);
        wallet.submitTransaction(address(0x5), 100);
        vm.stopPrank();

        vm.prank(nonOwner);
        vm.expectRevert("Not owner");
        wallet.confirmTransaction(0);
    }

    function testOnlyOwnerCanExecute() public {
        vm.startPrank(owner1);
        wallet.submitTransaction(address(0x5), 100);
        wallet.confirmTransaction(0);
        vm.stopPrank();

        vm.prank(owner2);
        wallet.confirmTransaction(0);

        vm.prank(nonOwner);
        vm.expectRevert("Not owner");
        wallet.executeTransaction(0);
    }

    function testRevertIfTransactionDoesNotExist() public {
        vm.prank(owner1);
        vm.expectRevert("Transaction does not exist");
        wallet.confirmTransaction(0);
    }

    function testRevertIfAlreadyConfirmed() public {
        vm.startPrank(owner1);
        wallet.submitTransaction(address(0x5), 100);
        wallet.confirmTransaction(0);
        vm.expectRevert("Transaction already confirmed");
        wallet.confirmTransaction(0);
        vm.stopPrank();
    }

    function testRevertIfAlreadyExecuted() public {
        vm.startPrank(owner1);
        wallet.submitTransaction(address(0x5), 100);
        wallet.confirmTransaction(0);
        vm.stopPrank();

        vm.prank(owner2);
        wallet.confirmTransaction(0);

        vm.prank(owner1);
        vm.expectRevert("Transaction already executed");
        wallet.executeTransaction(0);
    }

    function testEventEmittedOnSubmitTransaction() public {
        vm.startPrank(owner1);

        vm.expectEmit(true, true, true, true);
        emit MultiSigWalletOptimized.Submission(0);
        wallet.submitTransaction(address(0x5), 100);

        vm.stopPrank();
    }

    function testEventEmittedOnConfirmation() public {
        vm.startPrank(owner1);
        wallet.submitTransaction(address(0x5), 100);

        vm.expectEmit(true, true, true, true);
        emit MultiSigWalletOptimized.Confirmation(owner1, 0);
        wallet.confirmTransaction(0);

        vm.stopPrank();
    }

    function testEventEmittedOnExecution() public {
        vm.startPrank(owner1);
        wallet.submitTransaction(address(0x5), 100);
        wallet.confirmTransaction(0);
        vm.stopPrank();

        vm.prank(owner2);

        vm.expectEmit(true, true, true, true);
        emit MultiSigWalletOptimized.Execution(0);
        wallet.confirmTransaction(0);
    }
}