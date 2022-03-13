// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

contract GatekeeperTwo {
    address public entrant;

    // To pass gate one, we want to create a maliciuos contract and call the enter function. msg.sender will then be our separate Smart Contract.
    modifier gateOne() {
        require(msg.sender != tx.origin);
        _;
    }

    modifier gateTwo() {
        uint256 x;
        /// @dev 'inline assembly' allows us to access the EVM at a lower level for finer control.
        assembly {
            /// @dev inside these curley braces gives us access to opcodes.
            /// @dev 'extcodesize' gives the Smart Contracts code size.
            /// @dev caller() being passed into extcodesize gives us the size of the Contract that is calling the enter function.
            /// @dev extcodesize is assigned to x.
            x := extcodesize(caller())
        }
        /// @dev the size of the calling contract must == 0.
        require(x == 0);
        _;
    }

    modifier gateThree(bytes8 _gateKey) {
        require(
            /// @dev operand A uint64(bytes8(keccak256(abi.encodePacked(msg.sender)))) xor ^ operand B uint64(_gateKey) must equal == operand C uint64(0) - 1
            uint64(bytes8(keccak256(abi.encodePacked(msg.sender)))) ^
                uint64(_gateKey) ==
                uint64(0) - 1
        );
        _;
    }

    function enter(bytes8 _gateKey)
        public
        gateOne
        gateTwo
        gateThree(_gateKey)
        returns (bool)
    {
        entrant = tx.origin;
        return true;
    }
}

///// BITWISE OPERATORS ///// - Let us manipulate bits and bites.
// Usually used for low level operations such as networking, data compression, security encryption, operations, serial port data transference and communication.
/*
    &: and (x,y) bitwise and of x and y; where 1010 & 1111 == 1010
    |: or (x,y) bitwise or of x and y; where 1010 | 1111 == 1111
    ^: xor (x,y) bitwise xor of x and y; where 1010 ^ 1111 == 0101
        Example as our code uses the xor operator;
            Comparing 1010 ^ 1111 
            1 = true
            0 = false
            IF there is 2 trues, the outcome is false.. IF there is 1 true and 1 false, the outcome is true.
                Example {
                    1010
                    1111
                    ----
                    0101
                }
        Example - IF {
            A xor of B == C (1010 ^ 1111 == 0101)
            A xor of C == B (1010 ^ 0101 == 1111)
        }

    ~: not (x,y) bitwise not of x; where 1010 --0101
*/
// The main reason a higher level solidity developer would want to use these operators is for compression, to pack data into a smaller space.
// Also to perhaps make calculations execute faster.
