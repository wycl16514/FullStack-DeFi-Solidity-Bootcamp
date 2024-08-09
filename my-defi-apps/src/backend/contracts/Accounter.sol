//SPDX-License-Identifier: MIT

pragma solidity ^0.8.12;

contract Accounter {
    uint public totalBalance;

    constructor() {
        totalBalance = 0;
    }

    function saving() public payable {
        totalBalance += msg.value;
    }

    function getContractBalance() public view returns (uint) {
        return address(this).balance;
    }

    function takeAll() public {
        address payable to = payable(msg.sender);
        to.transfer(getContractBalance());
    }

    function takeToAddress(address payable to) public {
        to.transfer(getContractBalance());
    }
}
