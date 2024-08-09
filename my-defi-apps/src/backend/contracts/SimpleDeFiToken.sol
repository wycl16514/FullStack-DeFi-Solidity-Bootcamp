// SPDX-License-Identifier: MIT
//you need to use compiler version no smaller than 0.8.0
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "hardhat/console.sol";

/*
ERC20 is a standard use to create money coins, it is used to create given number of 
objects each one has the same value, NFT, is oppsite to ERC20, each object of NFT
will have different value
*/
//contract is just like class in c++, java , js , python
//is , extend in java or js,
//constructor is initializer for the contract, __init__ in python
//constructor in class of js,
contract SimpleDeFiToken is ERC20 {
    constructor() ERC20("Simple DeFi Token", "SDFT") {
        //init SimpleDeFiToken instance here
        //super()
        //_mint is provided by ERC20, which is used to create given number of virtual objects
        //each objects has the same value
        //Fed printing dollars
        //msg is an global variable used to get info about the running environment
        //of the contract,
        //sender is the id for whom is deploying this contract,
        //sender is markder for the man who control this control
        //sender is a string just like you social security number of id number
        //a coin is 1e18, coint number = 1e24 / 1e18 = 1000,000
        _mint(msg.sender, 1e24);
    }

    function transferWithAutoBurn(address to, uint256 amount) public {
        /*
        Destroy given amount of money of the sender and transfer the remaining
        amount to the recipient
        */
        require(balanceOf(msg.sender) >= amount, "Not enough tokens");
        uint256 burnAmount = amount / 10;
        // console.log(
        //     "Burning %s from %s, balance is %s",
        //     burnAmount,
        //     to,
        //     balanceOf(to)
        // );
        //provided by ERC20, used to destroy given number of tokens
        _burn(msg.sender, burnAmount);
        //transfer remainning amount to other
        transfer(to, amount - burnAmount);
    }
}

/*
smart contract always invovles with money or assets, little loopholes in your logic,
you will cause huge demage to your own assets,

0x5FbDB2315678afecb367f032d93F642f64180aa3
*/
