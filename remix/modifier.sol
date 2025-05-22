// SPDX-License-Identifier: MIT
pragma solidity 0.8.30; 

// OOP 
// SPDX-License-Identifier: MIT
pragma solidity 0.8.30; 


contract SecondCoin {
    address public minter;
    mapping (address => uint) public balances;

    event sent(address from, address to, uint amount);

    modifier onlyMinter {
        require(msg.sender == minter, "You are not the minter!");
        _;
    }
    modifier hasEnoughMoney(uint amount) {
        require(amount <= balances[msg.sender], "You do not have enough money!");
        _;
    }
    modifier isValidAmount(uint amount) {
        require(amount < 1e60, "Amount is too large!");
        _;
    }

    constructor () {
        minter = msg.sender;

    }

    function mint(address receiver, uint amount) public onlyMinter isValidAmount(amount) {
        balances[receiver] += amount;
    }
     
    function send(address receiver, uint amount) public hasEnoughMoney(amount) {
        balances[msg.sender] -= amount;
        balances[receiver] += amount;
        emit sent(msg.sender, receiver, amount);
    }
}