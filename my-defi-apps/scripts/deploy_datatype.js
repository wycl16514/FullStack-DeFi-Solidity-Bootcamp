const { ethers } = require("hardhat")

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
} catch (err) {
    console.err(err)
    process.exitCode = 1
}