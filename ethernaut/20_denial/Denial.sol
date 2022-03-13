// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract Denial {
    using SafeMath for uint256;
    address public partner; // withdrawal partner - pay the gas, split the withdraw
    address payable public constant owner = address(0xA9E);
    uint256 timeLastWithdrawn;
    mapping(address => uint256) withdrawPartnerBalances; // keep track of partners balances

    function setWithdrawPartner(address _partner) public {
        partner = _partner;
    }

    // withdraw 1% to recipient and 1% to owner
    function withdraw() public {
        uint256 amountToSend = address(this).balance.div(100);
        // perform a call without checking return
        // The recipient can revert, the owner will still get their share
        partner.call{value: amountToSend}("");
        owner.transfer(amountToSend);
        // keep track of last withdrawal time
        timeLastWithdrawn = now;
        withdrawPartnerBalances[partner] = withdrawPartnerBalances[partner].add(
            amountToSend
        );
    }

    // allow deposit of funds
    receive() external payable {}

    // convenience function
    function contractBalance() public view returns (uint256) {
        return address(this).balance;
    }
}

///// NOTES /////
// The difference between 'address' and 'address payable'
/*
    There are 3 different methods to send a transaction in Solidity - .transfer() .send() .call()

    // TRANSFER //
        function depositUsingTransfer(address payable _to) public payable {
            _to.transfer(msg.value); // 2300 Gas
        }

        - The transfer _to address must be denoted as 'payable'
        - The transfer method forwards 2300 Gas to the receiving contract which is sufficient enough for the receiving contract to emit an event.
        - The 2300 Gas is also hard coded in order to prevent reentrancy
        - IF the receiving contract has no receive() or fallback() then transfer method will throw an error


    // SEND //
    function depositUsingSend(address payable _to) public payable {
        bool sent = _to.send(mag.value); //2300 Gas
        require(sent, "Failure! Ether not sent!");
    }

    - Send is similar to transfer in the sense that it sends the minimal amount of gas to the receiving contract
    - Send will not throw an error. Instead, it will return a true or false Boolean. You can capture tgis bool as the return value.
 

    // CALL //
    function depositUsingCall(address payable _to) public payable {
        (bool sent, bytes memory data) = _to.call{gas: 1000, value: msg.value}("");
        require(sent, "Failure! Ether not sent!");
    }

    - Call is the recommended method to use for transfers form one contract to another.
    - It is like a low level function call that you can use in Solidity to call any other function in any other contract.
    - The .call() function allows you to call any other function on Ethereum. It takes in some metdata of value. 
    - IF the paretnthesis following the call is empty (""), it will trigger the receiving contracts receive() or fallback() function.
    - It does the same thing as send and transfer but it also sends back the data that is returned from the function.
    - Inside the last parenthesis, we can also pass in any encoded function signature to interact with other functions.
    - We can also specify how much gas we want to send with the function call to the receiving contract. 
    - If left blank, the receiving contract will receive whatever gas is left over after out function call.


         IF you want to use the 'transfer()' or 'send()' method in solidity, you must specify the address as 'payable'
         The 'call()' method does NOT require an address to be specified as 'payable'

         The gas required to run opcodes in the EVM is always changing, it is never the same. THe hardcoded 2300 gas used in
         the send and transfer functions could one day be far too much. This could allow all sorts of issues because you're
         giving the receiving contract more opportunity to run logic inside of the receive or fallback functions.
         .call() gives us the option to be specific with what gas we want to forward. 

         Remember also against reentrancy - Checks / Effects / Interactions.
    */
