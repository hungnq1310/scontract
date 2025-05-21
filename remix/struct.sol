// SPDX-License-Identifier: MIT
pragma solidity 0.8.30;

contract Game {

    uint public countPlayer = 0;
    // Player[] public players; // NOT OPTIMAL, USE MAPPING INSTEAD
    mapping (address => Player) public players;

    struct Player {
        address playerAddress;
        string name;
        uint age;
        string sex;
    }

    function createPlayer(string memory name, uint age, string memory sex) public {
        // players.push(Player(name, age, sex));
        players[msg.sender] = Player(msg.sender, name, age,sex);
        countPlayer += 1;
    }

    // function getPlayer(f)

}