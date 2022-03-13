// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract Fallback {
    using SafeMath for uint256;
    mapping(address => uint256) public contributions;
    address payable public owner;

    constructor() public {
        owner = msg.sender;
        contributions[msg.sender] = 1000 * (1 ether);
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "caller is not the owner");
        _;
    }

    /// @notice 1 way to complete this challenge would be to contribute until we store more ether than the current owner...
    function contribute() public payable {
        require(msg.value < 0.001 ether);
        contributions[msg.sender] += msg.value;
        if (contributions[msg.sender] > contributions[owner]) {
            owner = msg.sender;
        }
    }

    function getContribution() public view returns (uint256) {
        return contributions[msg.sender];
    }

    /// @notice After we complete the instructions below in the receive() function, we may withdraw the balance of this contract.
    function withdraw() public onlyOwner {
        owner.transfer(address(this).balance);
    }

    /// @notice If an address pays to this contract greater than 0 ether and already holds greater than 0 ether, they become the owner...
    receive() external payable {
        /// @notice We can call the contribute() function to satisfy the 2nd condition of this require statement.
        /// @notice We can then sendTransaction() to this contract to satisfy the 1st condition of this require statement.
        /// @notice We now own this contract.
        require(msg.value > 0 && contributions[msg.sender] > 0);
        owner = msg.sender;
    }
}
