// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;


contract Crud {
    struct Player {
        uint256 id;
        string name;
    }

    Player[] public players;
    uint256 public nextId = 1;

    function createPlayer(string memory _name) public {
        // not wanna have the same id
        players.push(Player(nextId, _name));
        nextId++;
    }

    function readPlayer(uint256 _id) public view returns (uint256, string memory) {
        require(_id < nextId, "Player does not exist");
        Player storage player = players[_id];
        return (player.id, player.name);
    }

    function updatePlayer(uint256 _id, string memory _name) public {
        require(_id < nextId, "Player does not exist");
        Player storage player = players[_id];
        player.name = _name;
    }

    function deletePlayer(uint256 _id) public {
        require(_id < players.length, "Player does not exist");

        // Move the last player into the slot to delete
        players[_id] = players[players.length - 1];
        players.pop(); // Remove the duplicate at the end
    }
    

    function getPlayers() public view returns (Player[] memory) {
        return players;
    }


} 