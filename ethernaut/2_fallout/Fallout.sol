// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract Fallout {
    using SafeMath for uint256;
    mapping(address => uint256) allocations;
    address payable public owner;

    /// @notice There is a typo in the 'constructor' name.
    /// @notice Inspecting the ABI will show this as a normal function, not as a constructor as intended.
    /// @notice Whoever calls this function will become the owner of this contract.
    function Fal1out() public payable {
        owner = msg.sender;
        allocations[owner] = msg.value;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "caller is not the owner");
        _;
    }

    function allocate() public payable {
        allocations[msg.sender] = allocations[msg.sender].add(msg.value);
    }

    function sendAllocation(address payable allocator) public {
        require(allocations[allocator] > 0);
        allocator.transfer(allocations[allocator]);
    }

    function collectAllocations() public onlyOwner {
        msg.sender.transfer(address(this).balance);
    }

    function allocatorBalance(address allocator) public view returns (uint256) {
        return allocations[allocator];
    }
}
