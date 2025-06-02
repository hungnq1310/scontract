// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
import "./ERC721Token.sol";

contract KittyGame  is ERC721Token {

    string public name;
    string public symbol;
    string public baseTokenURI;
    address public admin;
    mapping(uint256 => address) private kitties; 
    uint public nextKittyId;

    constructor(
        string memory _name, 
        string memory _symbol, 
        string memory _baseTokenURI
    ) public ERC721Token(_name, _symbol, _baseTokenURI) {
        // Constructor logic can be added here if needed
        admin = msg.sender;

    }

    struct Kitty {
        uint256 id;
        uint generation;
        HairColor hairColor;
        EyeColor eyeColor;
    }

    enum HairColor { 
        BLACK, 
        BROWN, 
        BLONDE, 
        RED, 
        GREY, 
        WHITE 
    }
    enum EyeColor { 
        BLUE, 
        GREEN, 
        BROWN, 
        HAZEL, 
        GRAY, 
        AMBER 
    }

    
    function mint() external {
        require(msg.sender == admin, "Only admin can mint tokens");
        kitties[nextKittyId] = Kitty(
            nextKittyId,
            1,
            HairColor(random(8)),
            EyeColor(random(10))
        );
        // mint the token
        _mint(msg.sender, nextKittyId);
        nextKittyId++;
    }


    function random(uint256 _max) internal view returns (uint256) {
        return uint256(keccak256(abi.encodePacked(block.timestamp, block.difficulty, msg.sender))) % _max;
    }


    function breed(uint256 _kittyId1, uint256 _kittyId2) external {
        // check
        require(msg.sender == admin, "Only admin can breed kitties");
        require(_kittyId1 != _kittyId2, "Cannot breed the same kitty");
        require(_kittyId1 < nextKittyId && _kittyId2 < nextKittyId, "Invalid kitty IDs");
        require(ownerOf(_kittyId1) == msg.sender && ownerOf(_kittyId2) == msg.sender, "You do not own these kitties");

    
        // Retrieve the kitties
        Kitty storage kitty1 = kitties[_kittyId1];
        Kitty storage kitty2 = kitties[_kittyId2];

        // Determine the new kitty's generation and colors
        uint256 maxGen = kitty1.generation > kitty2.generation ? kitty1.generation : kitty2.generation;
        uint256 genA = random(4) > 1 ? kitty1.generation : kitty2.generation;
        uint256 genB = random(4) > 1 ? kitty2.generation : kitty1.generation;

        // Create the new kitty
        uint256 newKittyId = nextKittyId;
        kitties[newKittyId] = Kitty(
            newKittyId,
            maxGen,
            HairColor(genA),
            EyeColor(genB)
        );

        // mint the new token
        _mint(msg.sender, newKittyId);
        nextKittyId++;
        
    }


}  