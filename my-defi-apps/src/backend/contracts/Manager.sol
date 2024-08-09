// SPDX-License-Identifier: MIT

pragma solidity ^0.8.12;
//convert number to string
import "@openzeppelin/contracts/utils/Strings.sol";

contract Manager {
    string public message;
    //unit => uint256
    uint public visitorCount;
    address public owner;
    //need to pay to change its content
    string public payedMsg;

    constructor() {
        visitorCount = 0;
        owner = msg.sender;
        payedMsg = "hello world";
    }

    function greetVisitor() public pure returns (string memory) {
        /*
        if the function never read or write to members of the contract, 
        then it should use pure keyword,
        the length of the following string is fixed
        */
        return "Hi, welcome to our smart contract";
    }

    function visit(address visitor) public {
        if (visitor == owner) {
            string memory msg1 = "hi boss, there are ";
            string memory count = Strings.toString(visitorCount);
            string memory msg2 = " of visitors coming";
            string memory result = string.concat(msg1, count);
            message = string.concat(result, msg2);

            return;
        } else {
            visitorCount += 1;
        }

        message = greetVisitor();
    }

    function updatePayedMsg(string memory _msg) public payable {
        if (msg.value >= 1 ether) {
            payedMsg = _msg;
        } else {
            /*
            if the money is not enough, then we send back the money and leave
            the msg unchanged.

            The address type is no so basic , in that it is a kind of class
            ,that's why it can be converted to other kind of class such as 
            payable

            msg.value in wei, 1 ehter = 10^18 wei
            */
            payable(msg.sender).transfer(msg.value);
            payedMsg = "hello world";
        }
    }
}
