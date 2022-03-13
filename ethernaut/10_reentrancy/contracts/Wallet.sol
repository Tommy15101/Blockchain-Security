//SPDX-License-Identifier: MTI

pragma solidity >=0.6.10;

/// @title Reentrancy Example
/// @author Tommy Atkins
/// @notice Simple an example in relation to Smart Contract Security - Sourced from Ethernaut / DAO Wallet / Mark Muskardin @Smart Contract Security

/*
    A Reentracy attack can occur when a Smart Contracts function is called and interacts with an external untrusted
    Smart Contract before the initial function is able to complete execution and resolve any effects.
*/

contract Wallet {
    /// @notice A mapping of Ethereum Adress' and their balance of Ether
    mapping(address => uint256) public balances;

    /// @notice A Deposit Function
    /// @dev Creates an entrance into the balances mapping above
    function deposit() public payable {
        balances[msg.sender] += msg.value;
    }

    /// @notice A Withdraw Function
    /// @dev This function has a reentrancy vulnerability
    /// @param _amount equals the Ethereum to withdraw
    function withdraw(uint256 _amount) public {
        /// @notice Requires that the balance of the function caller is greater than or equal to the amount passed in
        require(balances[msg.sender] >= _amount);

        /// @notice If the above requirement is met, msg.sender.call will allow the user the execute a withdraw.
        /// @notice '.call' is one way to make a transaction on the blockchain. Other ways are '.send' & '.transfer'
        /// @notice msg.sender can be a user or a Smart Contract.
        /// @notice Because there is no function name called in the '.call' curly braces, it is going to call the fallback function of msg.sender by default
        (bool sent, ) = msg.sender.call{value: _amount}("");
        require(sent, "Did not send");

        /// @notice Only once the above requirements are met, will the balances mapping be updated to reflect the transaction
        balances[msg.sender] -= _amount;
    }

    /// @notice A simple function to show the balance of the address interaction with this function
    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }
}
