const { ethers } = require("hardhat")
async function main() {
    //get the deploy account, normally is Account#0
    const [deployer] = await ethers.getSigners()
    const tokenContractFactory = await ethers.getContractFactory("SimpleDeFiToken")
    //send the bytecode in artifacts directory to the virutal machine
    const token = await tokenContractFactory.deploy()
    //wait for the complete of deployment and we can get the depolyment address
    await token.waitForDeployment()
    //address of contract just like the port for your server program
    console.log("Simple DeFi token contract address: ", token.target)
    console.log("Deployer address: ", deployer.address)
    const balance = await deployer.provider.getBalance(deployer.address)
    console.log("Deployer ETH balance: ", balance.toString())
}

try {
    main()
} catch (err) {
    console.error(err)
    process.exitCode = 1
}