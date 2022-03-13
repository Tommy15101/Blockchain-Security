//SPDX-License-Identifier: MTI

pragma solidity >=0.6.10;

/// @title FrontRunning Example
/// @author Tommy Atkins
/// @notice An example in relation to Smart Contract Security - Sourced from @Smart Contract Programmer https://www.smartcontract.engineer/

/// @notice If the user can solve this challenge, they will be rewarded with the balance of this Smart Contract.

contract FrontRunning {
    bytes32 public hash;

    constructor(bytes32 _hash) public payable {
        hash = _hash;
    }

    /// @notice All one has to do is pass in the correct hash to win the challenge.
    /// @notice To Front Run this contract, one could simply search the TX Pool for the solution, submit the solution themselves and pay higher gas to ptentially have their Tx mined first.
    function solve(string memory solution) public {
        require(hash == keccak256(abi.encodePacked(solution)), "Wrong Answer!");

        (bool sent, ) = msg.sender.call{value: address(this).balance}("");
        require(sent, "Failed to send Eth");
    }
}
