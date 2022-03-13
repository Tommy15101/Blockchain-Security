// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

contract Vault {
    bool public locked;
    bytes32 private password; /// Bad idea to store passwords or sensitive information on the blockchain...

    constructor(bytes32 _password) public {
        locked = true;
        password = _password;
    }

    function unlock(bytes32 _password) public {
        if (password == _password) {
            locked = false;
        }
    }
}

/// @notice web3.eth.getStorageAt()
// web3.eth.getStorageAt(address, position [, defaultBlock] [, callback])
// This will return a hex string
// We can then use web3.utils.toAscii('pass in our hex string') to return the password.

// https://web3js.readthedocs.io/en/v1.2.11/web3-eth.html#getstorageat
