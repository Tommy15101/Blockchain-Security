// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

contract King {
    address payable king;
    uint256 public prize;
    address payable public owner;

    constructor() public payable {
        owner = msg.sender;
        king = msg.sender;
        prize = msg.value;
    }

    receive() external payable {
        require(msg.value >= prize || msg.sender == owner);
        /// @dev we need to claim ownership of the contract and not allow anyone else to send us as the king any ethereum.
        king.transfer(msg.value);
        king = msg.sender;
        prize = msg.value;
    }

    function _king() public view returns (address payable) {
        return king;
    }
}
///////////////// This Game Is A CLassic Ponzi Scheme /////////////////
// The classic King of the Ether Game - https://www.kingoftheether.com/thrones/kingoftheether/index.html
