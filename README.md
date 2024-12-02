1-9 ✅ (1 point * 9 maybe)

10 ✅ (5 point maybe)


## 1. Arithmetic Operators

AdditionOptimized
The unchecked block was added to the addition function to disable overflow checks. This reduces gas costs by skipping unnecessary runtime checks for overflow.

SubtractionOptimized
Similarly, the unchecked block was added to the subtraction function to bypass overflow checks during subtraction, optimizing gas usage.

DivisionOptimized
Division operations were replaced with bitwise shifts:
divisionBy2 uses number >> 1 instead of number / 2.
divisionBy128 uses number >> 7 instead of number / 128.
Bitwise operations (>>) are significantly cheaper than arithmetic division.

![](/src/static/1.png)


## 2. Array Lenght

ArrayLengthOptimized
The callFor function was optimized by storing the array length in a local variable before the loop:

```solidity

uint256 length = myArray.length;
```
This avoids repeated reads of myArray.length from storage during each iteration, reducing gas costs.
Incrementing the loop variable i was moved into an unchecked block:

```solidity
unchecked {
    i++;
}
```
This disables overflow checks on the loop counter, which is safe in this context and further reduces gas usage.

![](/src/static/2.png)


## 3. CalldataMemory

CalldataMemoryOptimized
Loop Optimization:

The myArray[i] access is cached in a local variable item:
solidity
Копировать код
uint256 item = myArray[i];
This reduces repeated memory lookups, saving gas.
Unchecked Addition:

The addition operation is enclosed within an unchecked block:
```solidity
unchecked {
    sum += item;
}
```
This skips overflow checks for the addition, which is safe in this controlled loop context, further reducing gas costs.

![](/src/static/3.png)


## 4. Loops

Optimized Loops with unchecked:
Use of unchecked:

Added unchecked blocks to remove overflow checks during arithmetic operations. This is safe because the loops operate within predefined bounds.
Example:
```solidity
unchecked {
    sum += i;
    i++;
}
```
Removed Redundant Operations:

In the for loop, the increment (i++) was moved inside the unchecked block to avoid additional operations outside the loop body.
Preserved Functionality:

The loops retain their original purpose: summing numbers through iterations.

![](/src/static/4.png)

## 5. PackVariables

PackVariablesOptimized
Variable Packing:

Rearranged variable declarations to pack smaller variables into fewer storage slots:
solidity
Копировать код
uint8 one;
uint8 six;
uint8[30] four;
bytes14 five;
bytes18 three;
uint256 two;
Smaller variables (uint8 and bytes14) are grouped together at the top to minimize storage usage.
Manual Copying of Arrays:

Since arrays in calldata cannot be directly assigned to storage, elements of _four are copied manually in a loop:
```solidity
for (uint256 i = 0; i < 30; i++) {
    four[i] = _four[i];
}
```
Preserved Functionality:

The logic for setting variables remains the same while improving storage efficiency.

![](/src/static/5.png)


## 6. Errors

Custom Error Introduced:

Replaced the require statement with a custom error NotOwner():
```solidity
if (owner != msg.sender) {
    revert NotOwner();
}
```
Custom errors are more gas-efficient compared to require with a string message.
Functionality Preserved:

The onlyOwner modifier retains the same logic, ensuring only the owner can call protected functions.

![](/src/static/6.png)


## 7. Swap
SwapOptimized
Replaced Arithmetic Operations with Bitwise XOR:

The arithmetic operations for swapping values (+ and -) were replaced with XOR operations:
```solidity
a = a ^ b;
b = a ^ b;
a = a ^ b;
```
XOR operations are computationally cheaper and avoid overflow issues.
Preserved Functionality:

The function still swaps the values of a and b correctly, but with a more gas-efficient implementation.

![](/src/static/7.png)


## 9. Nesterdlf
NestedIfOptimized
Simplified Conditional Logic:

Replaced the nested if statement with a single return statement:
```solidity
return number > 0 && number < 100 && number != 50;
```
This removes unnecessary branching and improves code readability.
Reduced Gas Usage:

By directly returning the result of the logical expression, the contract avoids the overhead of conditional checks and explicit if statements.

![](/src/static/9.png)

## 10 MultisigWallet

MultiSigWalletOptimized
Optimized Owner Storage:

Replaced the owners array with a mapping(address => bool) for O(1) owner verification:
```solidity
mapping(address => bool) public isOwner;
```
This reduces gas costs when checking if an address is an owner.
Added Getter Functions:

Introduced getTransactionCount to retrieve the number of transactions:
```solidity

function getTransactionCount() public view returns (uint256) {
    return transactions.length;
}
```
Introduced getTransaction to retrieve transaction details:
```solidity
function getTransaction(uint256 transactionId) public view returns (
    address destination,
    uint256 value,
    uint256 confirmationCount,
    bool executed
) {
    MultiSigTransaction storage txn = transactions[transactionId];
    return (txn.destination, txn.value, txn.confirmationCount, txn.executed);
}
```
Optimized Transaction Structure:

Reduced redundant data storage by omitting unnecessary fields like transactionID.
Improved Gas Efficiency:

Avoided linear searches by relying on mappings and storage-efficient layouts.
Replaced storage-heavy structures with function calls where applicable.


![](/src/static/10.png)

#### As we can see now, gas consumption has significantly decreased