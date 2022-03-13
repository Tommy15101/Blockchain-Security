// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

contract Preservation {
    // public library contracts
    address public timeZone1Library;
    address public timeZone2Library;
    address public owner;
    uint256 storedTime;
    // Sets the function signature for delegatecall
    bytes4 constant setTimeSignature = bytes4(keccak256("setTime(uint256)"));

    constructor(
        address _timeZone1LibraryAddress,
        address _timeZone2LibraryAddress
    ) public {
        timeZone1Library = _timeZone1LibraryAddress;
        timeZone2Library = _timeZone2LibraryAddress;
        owner = msg.sender;
    }

    // set the time for timezone 1
    function setFirstTime(uint256 _timeStamp) public {
        timeZone1Library.delegatecall(
            abi.encodePacked(setTimeSignature, _timeStamp)
        );
    }

    // set the time for timezone 2
    function setSecondTime(uint256 _timeStamp) public {
        timeZone2Library.delegatecall(
            abi.encodePacked(setTimeSignature, _timeStamp)
        );
    }
}

// Simple library contract to set the time

contract LibraryContract {
    // stores a timestamp
    uint256 storedTime;

    function setTime(uint256 _time) public {
        storedTime = _time;
    }
}

/*
    ///// DELEGATECALL /////
    DelegateCall: Low Level Solidity Function that allows us to call a function from another contract, BUT the state variables
    are not chaged within that called contract.. The state variables are changed within the calling contract.

    What's the point in calling functions from another contract to update ones own smart contract??
        - Many times there are interesting functions and delicate operations we would like to call and interact with.
        - Also to interact with contracts that supply re-usable libraries. 

        - The Key thing to remember is that delegate call will influence the state variables of the calling contract.

    ///// STORAGE /////
    Storage: Remember Solidity allows 32 bytes per storage slot. Slots start from 0 (0 based indexing)

    ///// NOTE /////
    Delegate call will NOT update the state variable of the same name, it will update the state variable of the same storage slot.
        contract LibraryContract {
            uint256 storedTime; [SLOT 0]
        }
        contract Preservation {
            address public timeZone1Library; [SLOT 0]
        }
*/
