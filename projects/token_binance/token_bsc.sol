// SPDX-License-Identifier: MIT
pragma solidity 0.8.30;

contract Token {

    // vars
    uint public totalSupply = 100000 * 10 ** 18; // total supply of tokens
    uint public decimals = 18; // number of decimals
    string public name = "Token"; // name of the token
    string public symbol = "TTK"; // symbol of the token



    // mapping
    mapping (address => uint) public balances; // mapping of addresses to their token balances
    mapping (address => mapping (address => uint)) public allowances; // mapping of addresses to their allowances


    // modifiers


    // events
    event transfered(address indexed from, address indexed to, uint value); // event for token transfer
    event approved(address indexed owner, address indexed spender, uint value); // event for token approval


    // constructor
    constructor() {
        balances[msg.sender] = totalSupply; // assign total supply to the contract deployer

    }


    // funcs
    function balancesOf(address _owner) public view returns (uint) {
        return balances[_owner]; // return the balance of the given address
    }

    function transfer(address _to, uint _value) public returns (bool) {
        require(balances[msg.sender] >= _value, "Insufficient balance"); // check if sender has enough tokens
        require(_to != address(0), "Invalid address"); // check if the recipient address is valid
        balances[msg.sender] -= _value; // deduct tokens from sender
        balances[_to] += _value; // add tokens to recipient
        emit transfered(msg.sender, _to, _value); // emit transfer event
        return true; // return true to indicate success
    }

    function transferFrom(address _from, address _to, uint _value) public returns (bool) {
        // authorize the transfer
        require(balancesOf(_from) >= _value, "Insufficient balance"); // check if sender has enough tokens
        require(allowances[_from][msg.sender] >= _value, "Allowance exceeded"); // check if allowance is sufficient 
        balances[_to] += _value;
        balances[msg.sender] -= _value; // deduct tokens from sender
        emit transfered(_from, _to, _value);
        return true; // return true to indicate success
    }

    function approve(address _spender, uint _value) public returns (bool) {
        allowances[msg.sender][_spender] = _value; // set allowance for the spender
        emit approved(msg.sender, _spender, _value); // emit approval event
        return true; // return true to indicate success
    }

}