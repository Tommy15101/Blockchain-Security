//SPDX-License-Identifier: MTI

pragma solidity >=0.6.10;

/// @title Reentrancy Example
/// @author Tommy Atkins
/// @notice Simple an example in relation to Smart Contract Security - Sourced from Ethernaut / DAO Wallet / Mark Muskardin @Smart Contract Security

/////////////////////////////////////////
////////// SOLUTION NUMBER ONE //////////
/////////////////////////////////////////

/// @notice This Solution comes from the Solidy best practices - Checks-Effects-Interaction
contract SolutionNumberOne {
    mapping(address => uint256) public balances;

    function deposit() public payable {
        balances[msg.sender] += msg.value;
    }

    /// @notice We have called the external function (line 16) before we updated the balances mapping (line 19).
    function withdrawVictim(uint256 _amount) public {
        /// @notice Checks if the below is true.
        require(balances[msg.sender] >= _amount);
        /// @notice Interactions occur - This is in the wrong place. It will execute and loop and never update the balances mapping.
        (bool sent, ) = msg.sender.call{value: _amount}("");
        require(sent, "Did not send");
        /// @notice Effects take place - This will never take place as the Attacker will drain the contract until its requirements are met.
        balances[msg.sender] -= _amount;
    }

    /// @notice We have moved the updated state variable balances mapping before the external function call.
    function withdrawSecure(uint256 _amount) public {
        /// @notice Checks if the below is true.
        require(balances[msg.sender] >= _amount);
        /// @notice Effects take place - The balances are updated.
        balances[msg.sender] -= _amount;
        /// @notice Interactions occur - The ether is withdrawn.
        (bool sent, ) = msg.sender.call{value: _amount}("");
        require(sent, "Did not send");
    }
}

/////////////////////////////////////////
////////// SOLUTION NUMBER TWO //////////
/////////////////////////////////////////

/// @notice This Solution is called a Mutex. A mutex places a 'lock' on a contracts state and only the owner of that lock can modily that state.
/// @notice A Mutex will basically lock a contract while a function is being executed, meaning only a single function can be called at any time.
contract SolutionNumberTwo {
    mapping(address => uint256) public balances;

    /// @dev This is our mutex internal variable
    bool internal locked;

    function deposit() public payable {
        balances[msg.sender] += msg.value;
    }

    /// @notice This is our mutex modifier. It get's executed before a function.
    modifier noReentrant() {
        require(!locked, "No re-entrancy!!!"); // Requires locked is False.
        locked = true; // Sets locked to True and executes function.
        _;
        locked = false; // Sets locked to False.
    }

    /// @notice MUTEX. The noReentrant modifier is added to this function. This will avoid the chance of reentrancy and looping with an external contract.
    /// @notice The noReentrant modifier will be locked and allow no other function calls until with withdraw function completes and the balances mapping is updated.
    function withdraw(uint256 _amount) public noReentrant {
        require(balances[msg.sender] >= _amount);

        (bool sent, ) = msg.sender.call{value: _amount}("");
        require(sent, "Did not send");

        balances[msg.sender] -= _amount;
    }
}
