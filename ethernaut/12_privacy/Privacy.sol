// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

contract Privacy {
    bool public locked = true; // Bool could share a memory slot IF the below variable would allow. [SLOT 0]
    uint256 public ID = block.timestamp; // Uint256 requires it's own slot in memory as it is 23 bites / 256 bits. [SLOT 1]
    uint8 private flattening = 10; // Uint8 [SLOT 2]
    uint8 private denomination = 255; // Uint8 [SLOT 2]
    uint16 private awkwardness = uint16(now);  // Uint16 [SLOT 2]
    bytes32[3] private data; // Bytes32 equals 1 slot. Array[0] = [SLOT 3] | Array[1] = [SLOT 4] | Array[2] = [SLOT 5]

    // Upon construction, the deployer is passing in the data to the fixed array.
    constructor(bytes32[3] memory _data) public {
        data = _data;
    }
    
    function unlock(bytes16 _key) public {
        // The key must equal the last element of the Fixed Data array in order to unlock.
        require(_key == bytes16(data[2]));
        locked = false;
    }
}

///// STORAGE /////
/*
    1. All state variables are accessible, even the ones stored as Private. We seen that in the vault challenge.
            - CONSTANTS are not stored in Storage.
    
    2. The order in which state variables are written matter for gas cost efficiency. Each slot has a 32 bites or 256 bits size.
            - Example; - Would cost more Gas...
                bool public boolVar             SLOT 0 = boolVar
                uint public uintVar             SLOT 1 = uintVar
                bytes4 public bytesVar          SLOT 2 = bytesVar

                struct Object {
                    uint8 uint8Var;             SLOT 3 = uint8Var
                    address addr;               SLOT 4 = addr 
                    uint8 uint8Var2;            SLOT 5 = uint8Var2
                }
            
            - Example 2; - Would cost LESS Gas...
                bool public boolVar             SLOT 0 = bytesVar , boolVar
                bytes4 public bytesVar          
                uint public uintVar             SLOT 1 = uintVar                 

                struct Object {
                    uint8 uint8Var;             SLOT 2 = uintVar2 , uintVar 1
                    uint8 uint8Var2;             
                    address addr;               SLOT 3 = addr        
                }
    
    3. Mappings and Dynamically Sized Arrays do not follow the same convention as above.
*/

///// TYPE CASTING /////
/*
    1. Implicit and Explicit Conversions - https://docs.soliditylang.org/en/v0.6.4/types.html

    2. See Attack contract for the explicit conversion...
*/