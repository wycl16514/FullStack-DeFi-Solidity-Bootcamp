// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract DataType {
    bool public myBool;
    /*
    uint8(1byte) ... uint96(12 bytes)
    int8(1byte) .... int96(12 bytes)

    by default myUint8 => 0
    0 <= uint8 <= 255

    myUint8 = myUint16; error
    */
    uint8 public myUint8;

    string public myString = "hello world";

    bytes public myBytes = "hello world"; //byte array

    address public myAddress; //byte array

    function setMyUint8(uint8 val) public {
        myUint8 = val;
    }

    function increaseUint8() public {
        myUint8++;
    }

    function decreaseUint8() public {
        myUint8--;
    }

    function setMyString(string memory _myString) public {
        /*
        two kinds of data storage in smart contract, one is memory, one is 
        storage, if we save data as memory, then we can change the data in anytime, 
        like RAM  in computer, but storage will like saving your data in database system,
        you can't change your data easily, you need to use some special method to change it,
        if you save your data as storage, your data will persistantly save on the network,
        and you can access the data with its original content.
        */
        myString = _myString;
    }

    function compareTwoString(
        string memory _myString
    ) public view returns (bool) {
        /*
        view keyword tells the compiler we won't change the status of the contract,
        we don't change any members of contract, view like const in c++ or js,

        compare two string? str1 == str2, error in smart contract,
        1, transfter the stirng into byte array, abi.encodePacked
        AABB => 0x4141424200000 ascii table
        2, using hash function to compute the byte array, keccak256
        3, compare the hash result
        */
        return
            keccak256(abi.encodePacked(myString)) ==
            keccak256(abi.encodePacked(_myString));
    }

    function setMyAddress(address _address) public {
        myAddress = _address;
    }

    function getAddressBalance() public view returns (uint) {
        //uint => uint32 ,uint64
        return myAddress.balance;
    }

    //write a setAddress method and set the myAddress to given address value
    //0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266

    function getCallerAddress() public view returns (address) {
        return msg.sender;
    }
}
