// SPDX-License-Identifier: MIT
pragma solidity 0.8.30;

contract Game {

    uint public countPlayer = 0;
    // Player[] public players; // NOT OPTIMAL, USE MAPPING INSTEAD
    mapping (address => Player) public players;
    enum Level {Beginner, Intermediate, Advance}

    struct Player {
        address playerAddress;
        string name;
        uint age;
        Level level;
        string sex;
        uint createTime;
    }

    function createPlayer(string memory name, uint age, string memory sex) public {
        // players.push(Player(name, age, sex));
        players[msg.sender] = Player(msg.sender,name,age,Level.Beginner,sex, block.timestamp);
        countPlayer += 1;
    }


    function getPlayerLevel(address player) view  public returns (Level) {
        return players[player].level;
    }

    function changePlayerLevel(address player) public {
        Player storage p = players[player];
        if ( block.timestamp >= p.createTime * 15 ) {
            p.level = Level.Intermediate;
        }
    }

}