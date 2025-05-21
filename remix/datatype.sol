// SPDX-License-Identifier: MIT
pragma solidity 0.8.30;

contract datatypes {
    bool MyBoolean = true;
    uint MyUnsignedInteger = 1234567890;
    int MySignedInteger = -1234567890;
    string MyString = "Hello, World!"; // always in double quotes
    address MyAddress = msg.sender; // address of the sender
}

