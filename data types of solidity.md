In this section, let's have some basic knowledge for solidity. We begin by introducing data types, the key point here is to understand address data type which is special for solidity compare with other languages. First we will 
check the bool type, let's create a new file named DataType.sol and put in following code:
```sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DataType {
    bool myBool;
}
```
Then let's write the script for deploying the aboved contract, in folder of script, create a file name deploy_datatype.js and have the following code:
```js
const {ethers} = require("hardhat")
async function main() {
    const [deployer] = await ethers.getSigners()
    const dataTypeContractFactory = await ethers.getContractFactory("DataType")
    const contract = await dataTypeContractFactory.deploy()
    await contract.waitForDeployment()

    console.log("DataType contract address: ", contract.target)
    console.log("Deployer address: ", deployer.address)
}

try {
    main()
} catch(err) {
    console.err(err)
    process.exitCode = 1
}
```
Before running the deploying script, we need to setup the hardhat VM by command "npx hardhat node",  and we need to compile the solidity file aboved by running "npx hardhat compile" then we setup another new console
and run the command to deploy our contract: "npx harhat run script/deploy_datatype.js --network localhost", then I get the address of my contract as following:
```sol
DataType contract address:  0x5FbDB2315678afecb367f032d93F642f64180aa3
Deployer address:  0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266
```
This time we can interact with the contract with hardhat console, let's run the console by "npx hardhat console --network localhost", and in the console we will get the instance of the contract by following code:
```js
const contract = await ethers.getContractAt("DataType", "0x5FbDB2315678afecb367f032d93F642f64180aa3") 
```
Then let's try to access the field of myBool:
```js
await contract.myBool
```
Then you will get undefined as result, that's because all data members in contract are by default private, which means you can't access them directly unless we add the public keyword as following:
```sol
bool public myBool;
```
Notice the "public" should behide the data type bool otherwise it will by a syntax error, after the changing aboved, we need to recompile and redeploy, then go into the console and try to access myBool again, this time we get:
```js
await contract.myBool()
```

The result is : "false". As you can see from the code of contract, we only defined a member named myBool and never define any method with the same name, but actuall we can call a method with name as the same as the public 
member, this is mechanism from smart contract, it automatically create a method with the same name as the public member and it will return the value of the member, by default all public member initialized to 0 of its type,
that is to say boolean type will init to false, integer type will to 0, and address type will be 0x0000000000000000000000000000000000000000.

The other most used data type is integer, solidity has two kind of integers: signed integer, and unsigned integer. If you don't init integer type member in the contract, they will be initialized to 0, integer has their own 
subcategory such as int8, int16, int32, int256, and uint8, uint16...uint256, the int8 and uint will use 1 byte and int16 and uint16 used 2 bytes up to int256 and uint256 used 8 bytes.
for example we change the
code for previous smart contract as following:
```sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DataType {
    bool public myBool;
    uint8 public myUint8;

    function setMyUint8(val uint8) public {
        myUint8 = val;
        /*
        it is not allowed to assigned value to different integer type such as
        uint16 val = 256;
        myUint8 = val; //error,
        */
    }

 function increaseMyUint8() public {
        //what happend if it bigger than 255?
        myUint8++;
    }

function decreaseMyUint8() public {
        //what happend if it smaller than 0
        myUint8--;
    }
}
```

Let's compile and deploy it to hardhat and verify with the contract, the key point is , we will set the value of myUint8 to 253 then increase it over 255 and see what happend, and set it to 2 which near 0 and decrease its value
to negative and see what happend, when we call increaseMyUint8 until the value of myUint8 bigger than 255, we will get the following error:
```sol
ProviderError: Error: VM Exception while processing transaction: reverted with panic code 0x11 (Arithmetic operation overflowed outside of an unchecked block)
```
The same will happend when we decrease its value smaller than 0. We very careful to prevent such low level error, trust me if you make such silly errors you will get fired by your boss. The other useful data type are string
and array, when we handling string we will meet a new keyword which is "memory", first we change our contract as following:
```sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DataType {
    bool public myBool;
    uint8 public myUint8;
    string public myString = "hello world";

    function setMyUint8(uint8 val) public {
        myUint8 = val;
        /*
        it is not allowed to assigned value to different integer type such as
        uint16 val = 256;
        myUint8 = val; //error,
        */
    }

    function increaseMyUint8() public {
        //what happend if it bigger than 255?
        myUint8++;
    }

    function decreaseMyUint8() public {
        //what happend if it smaller than 0
        myUint8--;
    }

    function setMyString(string memory _myString) public {
        /*
        There are two kinds of data storage in smart contract of string,
        one is memory, one is storage. storage just like save your data 
        on some kind of database, you can't change such data directly, you
        need to use some special methods to change them and saving data in such
        way will cause you more money. using memory is just like saving data in
        RAM, you can change them quickly and easily and such saving will not cost
        you too much money.
        */
        myString = _myString;
    }

    function compareTwoString(
        string memory _myString
    ) public view returns (bool) {
        /*
        view means this method will not change the state or members of the contract,
        just like const in c++,this will help compiler to optimize the code and make
        the binary smaller and save more money

        There is not way to compare string by using == as other langague, we need
        to using hash function to hash the two string into values and compare

        keccak256 is most useful hash function for smart contract
        and abi.encodePacked just change a string into binary bytes array
        such as "AABB" will change to 0x414142420000000.....
        */

        return
            keccak256(abi.encodePacked(myString)) ==
            keccak256(abi.encodePacked(_myString));
    }
}

```
Compile and deploy the contract and calling compareTwoString and get result as following:

![截屏2024-08-07 00 00 05](https://github.com/user-attachments/assets/425bf23c-c385-4b81-957d-fb7732760ed9)

There is another data type name bytes, which is byte array, we can assign string to such data type member and it will automatically change the string into ascii code or unicode if the string contains none lati character, 
for example we change the code of contract to following:
```sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DataType {
    bool public myBool;
    uint8 public myUint8;
    string public myString = "hello world";
    bytes public myBytes = "hello world";

    function setMyUint8(uint8 val) public {
        myUint8 = val;
        /*
        it is not allowed to assigned value to different integer type such as
        uint16 val = 256;
        myUint8 = val; //error,
        */
    }

    function increaseMyUint8() public {
        //what happend if it bigger than 255?
        myUint8++;
    }

    function decreaseMyUint8() public {
        //what happend if it smaller than 0
        myUint8--;
    }

    function setMyString(string memory _myString) public {
        /*
        There are two kinds of data storage in smart contract of string,
        one is memory, one is storage. storage just like save your data 
        on some kind of database, you can't change such data directly, you
        need to use some special methods to change them and saving data in such
        way will cause you more money. using memory is just like saving data in
        RAM, you can change them quickly and easily and such saving will not cost
        you too much money.
        */
        myString = _myString;
    }

    function compareTwoString(
        string memory _myString
    ) public view returns (bool) {
        /*
        view means this method will not change the state or members of the contract,
        just like const in c++,this will help compiler to optimize the code and make
        the binary smaller and save more money

        There is not way to compare string by using == as other langague, we need
        to using hash function to hash the two string into values and compare

        keccak256 is most useful hash function for smart contract
        and abi.encodePacked just change a string into binary bytes array
        such as "AABB" will change to 0x414142420000000.....
        */

        return
            keccak256(abi.encodePacked(myString)) ==
            keccak256(abi.encodePacked(_myString));
    }
}

```

Compile and deploy it and we can get myBytes as following:

![截屏2024-08-07 00 12 05](https://github.com/user-attachments/assets/07c9b640-e4c1-421f-aafe-5c0a0c811282)

One data type that is only special for solidity is address, this data type is just like the ip address for internet or bank account and used only to indentify an entity on the blockchain, 
actually its a byte array with 20 bytes, what make address funny is, it is not so "basic", it has a property called balance,let's check the code for how to use address type as following:
```sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DataType {
    bool public myBool;
    uint8 public myUint8;
    string public myString = "hello world";
    bytes public myBytes = "hello world";
    address public myAddress;

    function setMyUint8(uint8 val) public {
        myUint8 = val;
        /*
        it is not allowed to assigned value to different integer type such as
        uint16 val = 256;
        myUint8 = val; //error,
        */
    }

    function increaseMyUint8() public {
        //what happend if it bigger than 255?
        myUint8++;
    }

    function decreaseMyUint8() public {
        //what happend if it smaller than 0
        myUint8--;
    }

    function setMyString(string memory _myString) public {
        /*
        There are two kinds of data storage in smart contract of string,
        one is memory, one is storage. storage just like save your data 
        on some kind of database, you can't change such data directly, you
        need to use some special methods to change them and saving data in such
        way will cause you more money. using memory is just like saving data in
        RAM, you can change them quickly and easily and such saving will not cost
        you too much money.
        */
        myString = _myString;
    }

    function compareTwoString(
        string memory _myString
    ) public view returns (bool) {
        /*
        view means this method will not change the state or members of the contract,
        just like const in c++,this will help compiler to optimize the code and make
        the binary smaller and save more money

        There is not way to compare string by using == as other langague, we need
        to using hash function to hash the two string into values and compare

        keccak256 is most useful hash function for smart contract
        and abi.encodePacked just change a string into binary bytes array
        such as "AABB" will change to 0x414142420000000.....
        */

        return
            keccak256(abi.encodePacked(myString)) ==
            keccak256(abi.encodePacked(_myString));
    }

    function setMyAddress(address _address) public {
        myAddress = _address;
    }

    function getAddressBalance() public view returns (uint) {
        return myAddress.balance;
    }
}

```
Then compile and deploy it to hardhat, and in the hardhat console, we can get the address type member and call its methods like following:
```js
> await contract.myAddress()
'0x0000000000000000000000000000000000000000'
await contract.setMyAddress("0x3C44CdDdB6a900fa2b585dd299e03d12FA4293BC")
await contract.myAddress()
'0x3C44CdDdB6a900fa2b585dd299e03d12FA4293BC'
> await contract.getAddressBalance()
10000000000000000000000n
```
At the last line we get the balance for account 0x3C44CdDdB6a900fa2b585dd299e03d12FA4293BC and the amount for this account is 10^18 wei. Lastly we check the msg object and the sender field in this object, let's use some code
to interact with the msg object, as we have seen before, msg.sender records the caller address of the contract, let's try to call a method of the contract and check the caller address by using following code:
```sol
```



