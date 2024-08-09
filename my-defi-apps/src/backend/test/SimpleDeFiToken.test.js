const { ethers } = require("hardhat")
const { expect } = require("chai")

const toWei = (num) => ethers.parseEther(num.toString())
const fromWei = (num) => ethers.formatEther(num)

//create test suit, package with several unit test
describe("SimpleDeFiToken", () => {
    let deployer, user1, user2, token
    //it will run before the running of each unit test
    beforeEach(async () => {
        [deployer, user1, user2] = await ethers.getSigners()
        console.log("deployer addr: ", deployer.address)
        console.log("user1 addr: ", user1.address)
        console.log("user2 addr: ", user2.address)
        const tokenContractFactory = await ethers.getContractFactory("SimpleDeFiToken")
        token = await tokenContractFactory.deploy()
    })

    it("should have correct name, symbol, and total supply", async () => {
        expect(await token.name()).to.equal("Simple DeFi Token")
        expect(await token.symbol()).to.equal("SDFT")
        expect(await token.totalSupply()).to.equal(toWei(1000000))
    })

    it("should transfer from one to other", async () => {
        expect(await token.balanceOf(deployer.address)).to.equal(toWei(1000000))
        await token.connect(deployer).transfer(user1.address, toWei(5))
        expect(await token.balanceOf(deployer.address)).to.equal(toWei(999995))
        expect(await token.balanceOf(user1.address)).to.equal(toWei(5))
    })

    it("should revert to transaction fail", async () => {
        await token.connect(deployer).transfer(user1.address, toWei(5))
        try {
            await token.connect(user1).transfer(user2.address, toWei(10))
        } catch (err) {
            console.log("err: ", err)
            expect(await token.balanceOf(user1.address)).to.equal(toWei(5))
        }
    })

    it("should burn the right amount of transferWithAutoBurn", async () => {
        await token.connect(deployer).transfer(user1.address, toWei(5))
        await token.connect(user1).transferWithAutoBurn(user2.address, toWei(1))
    })
})