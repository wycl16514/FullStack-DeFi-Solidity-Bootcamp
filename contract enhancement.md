Smart contract has some funny features compare with tranditional program that is it can envovle money. Smart contract is not used for implmenet algorithm, it is main usage is for transfering assets or values. Which means it can
receive money or send out money. The main purpose of smart contract is to implement a set of transaction logic and when given conditions are meet, it will send out or receive assert automatically and the set of logic can be 
changed by no one.

Let's see how a contract can handle with money, the key point is the "payable" keyword, if a function can receive money to do some job than it nees the "payable" modifier such as following:

```sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;
//convert number to string
import "@openzeppelin/contracts/utils/Strings.sol";

contract Manager {
    string public message;
    uint public visitorCount;
    address private owner;
    //need to pay to change following string member
    string public payedMsg;

    constructor() {
        /*
        it is better to initialize members in contructor because we can send data
        to init them instead of fix the initialization value 
        */
        owner = msg.sender;
        visitorCount = 0;
        payedMsg = "hello world";
    }

    function greetVisitor() public pure returns (string memory) {
        /*
        if the function has nothing to do with the contract members, such as not reading
        or writing to contract members, then we can set it to pure
        */

        return "Hi, welcome to our smart contract";
    }

    //solidity is not allow to return
    function visit(address visitor) public {
        /*
        sol
        */
        if (visitor == owner) {
            string memory msg1 = "hi boss, there are ";
            string memory count = Strings.toString(visitorCount);
            string memory msg2 = " of visitors coming";
            string memory result = string.concat(msg1, count);
            result = string.concat(result, msg2);
            message = result;
            return;
        } else {
            visitorCount += 1;
        }

        message = greetVisitor();
    }

    function updatePayedMsg(string memory _msg) public payable {
        /*
        if the caller send enough amount of money,then we update the message,
        oterwise we leave the message along, msg.value can check the amount 
        of the money payed, and ehter is a key word for the unit of money
        */
        if (msg.value >= 1 ether) {
            //if pay more than 1 ether, than update the message
            //msg.value is in unit of wei ,1 ehter is 10^18 of wei
            payedMsg = _msg;
        } else {
            //if the money is not enough, send back the money and leave the
            //message unchanged
            /*
           The address type is not so basic in that it is a class type, and it 
           can convert to other class such as payable
           */
            payable(msg.sender).transfer(msg.value);
            payedMsg = "hello world";
        }
    }
}

```

Compile and deploy the contract, and we will interact with the contract as following:
```js
let contract = await ethers.getContractAt("Manager","0x5FbDB2315678afecb367f032d93F642f64180aa3")
```
Then we need to switch the caller to newe account:
```js
await contract.connect("0x70997970C51812dc3A010C7d01b50e0d17dc79C8")
```
And call the function with sending given amount of money:
```js
> await contract.updatePayedMsg("pay with 2.0 ethers", {value: ethers.parseEther("2.0")})
> await contract.payedMsg()
'pay with 2.0 ethers'
```
