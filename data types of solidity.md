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

