// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;


/// @title ERC-721 Non-Fungible Token Standard
/// @dev See https://eips.ethereum.org/EIPS/eip-721
interface ERC721 /* is ERC165 */ {
    /// @dev This emits when ownership of any NFT changes by any mechanism.
    ///  This event emits when NFTs are created (`from` == 0) and destroyed
    ///  (`to` == 0). Exception: during contract creation, any number of NFTs
    ///  may be created and assigned without emitting Transfer. At the time of
    ///  any transfer, the approved address for that NFT (if any) is reset to none.
    event Transfer(address indexed _from, address indexed _to, uint256 indexed _tokenId);

    /// @dev This emits when the approved address for an NFT is changed or
    ///  reaffirmed. The zero address indicates there is no approved address.
    ///  When a Transfer event emits, this also indicates that the approved
    ///  address for that NFT (if any) is reset to none.
    event Approval(address indexed _owner, address indexed _approved, uint256 indexed _tokenId);

    /// @dev This emits when an operator is enabled or disabled for an owner.
    ///  The operator can manage all NFTs of the owner.
    event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);

    /// @notice Count all NFTs assigned to an owner
    /// @dev NFTs assigned to the zero address are considered invalid, and this
    ///  function throws for queries about the zero address.
    function balanceOf(address _owner) external view returns (uint256);

    /// @notice Find the owner of an NFT
    /// @dev NFTs assigned to zero address are considered invalid, and queries
    ///  about them do throw.
    function ownerOf(uint256 _tokenId) external view returns (address);

    /// @notice Transfers the ownership of an NFT from one address to another address
    /// @dev Throws unless `msg.sender` is the current owner, an authorized
    ///  operator, or the approved address for this NFT. Throws if `_from` is
    ///  not the current owner. Throws if `_to` is the zero address. Throws if
    ///  `_tokenId` is not a valid NFT. When transfer is complete, this function
    ///  checks if `_to` is a smart contract (code size > 0). If so, it calls
    ///  `onERC721Received` on `_to` and throws if the return value is not
    ///  `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`.
    function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes calldata data) external payable;

    /// @notice Transfers the ownership of an NFT from one address to another address
    /// @dev This works identically to the other function with an extra data parameter,
    ///  except this function just sets data to "".
    function safeTransferFrom(address _from, address _to, uint256 _tokenId) external payable;

    /// @notice Transfer ownership of an NFT -- THE CALLER IS RESPONSIBLE
    ///  TO CONFIRM THAT `_to` IS CAPABLE OF RECEIVING NFTS OR ELSE
    ///  THEY MAY BE PERMANENTLY LOST
    /// @dev Throws unless `msg.sender` is the current owner, an authorized
    ///  operator, or the approved address for this NFT. Throws if `_from` is
    ///  not the current owner. Throws if `_to` is the zero address. Throws if
    ///  `_tokenId` is not a valid NFT.
    function transferFrom(address _from, address _to, uint256 _tokenId) external payable;

    /// @notice Change or reaffirm the approved address for an NFT
    /// @dev The zero address indicates there is no approved address.
    ///  Throws unless `msg.sender` is the current NFT owner, or an authorized
    ///  operator of the current owner.
    function approve(address _approved, uint256 _tokenId) external payable;

    /// @notice Enable or disable approval for a third party ("operator") to manage
    ///  all of `msg.sender`'s assets
    /// @dev Emits the ApprovalForAll event. The contract MUST allow
    ///  multiple operators per owner.
    function setApprovalForAll(address _operator, bool _approved) external;

    /// @notice Get the approved address for a single NFT
    /// @dev Throws if `_tokenId` is not a valid NFT.
    function getApproved(uint256 _tokenId) external view returns (address);

    /// @notice Query if an address is an authorized operator for another address
    function isApprovedForAll(address _owner, address _operator) external view returns (bool);
}


contract ERC721Token is ERC721 {
    // Implementation
    mapping(address => uint256) private ownerToTokenCount;
    mapping(uint256 => address) private idToOwner;
    bytes4 internal constant MAGIC_ON_ERC721_RECEIVED = 0x150b7a02;

    // Operator mapping
    mapping(address => mapping(address => bool)) private operatorApprovals;
    string public name;
    string public symbol;
    string public baseTokenURI;
    mapping(uint256 => string) private tokenURIs;

    // Contructor
    constructor(
        string memory _name,
        string memory _symbol,
        string memory _baseTokenURI
    ) public {
        // Constructor logic can be added here if needed
        name = _name;
        symbol = _symbol;
        baseTokenURI = _baseTokenURI;
    }
    
    function tokenURI(uint256 _tokenId) external view returns (string memory) {
        require(_tokenId > 0, "Token ID must be greater than zero");
        return string(abi.encodePacked(baseTokenURI, _tokenId));
    }

    function _mint(address _to, uint256 _tokenId) internal {
        // Check if the token already exists
        require(idToOwner[_tokenId] == address(0), "Token already exists");
        // Check if the recipient is a valid address
        require(_to != address(0), "Cannot mint to zero address");

        // Assign the token to the owner
        idToOwner[_tokenId] = _to;
        ownerToTokenCount[_to] += 1;

        // Emit Transfer event
        emit Transfer(address(0), _to, _tokenId);
    }

    // Functions
    function isContract(address _address) public view returns (bool) {
        uint256 codeSize;
        assembly {
            codeSize := extcodesize(_address)
        }
        return codeSize > 0;
    }

    function balanceOf(address _owner) external view override returns (uint256) {
        return ownerToTokenCount[_owner];
    }

    function ownerOf(uint256 _tokenId) external view override returns (address) {
        return idToOwner[_tokenId];
    }


    function transferFrom(address _from, address _to, uint256 _tokenId) external payable {
        // Check
        require(_from == msg.sender, "Not the owner of the token");
        require(_from == idToOwner[_tokenId], "Not the owner of the token");
        
        // transfer tokens
        ownerToTokenCount[_from] -= 1;
        ownerToTokenCount[_to] += 1;
        // set new owner
        idToOwner[_tokenId] = _to;
        emit Transfer(_from, _to, _tokenId);
    }

    function safeTransferFrom(address _from, address _to, uint256 _tokenId) external payable {
        _safeTransferFrom(_from, _to, _tokenId, "");
    }

    function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes calldata data) external payable{
        _safeTransferFrom(_from, _to, _tokenId, data);
    }

    // memory to bytes 
    function _safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes memory data) internal {
        require(_from == msg.sender, "Not the owner of the token");
        require(_from == idToOwner[_tokenId], "Not the owner of the token");
        // transfer tokens
        ownerToTokenCount[_from] -= 1;
        ownerToTokenCount[_to] += 1;
        idToOwner[_tokenId] = _to;
        emit Transfer(_from, _to, _tokenId);

        // Check if _to is a contract
        if (isContract(_to)) {
            // Call onERC721Received
            (bool success, bytes memory returnData) = _to.call(
                abi.encodeWithSelector(
                    MAGIC_ON_ERC721_RECEIVED,
                    msg.sender,
                    _from,
                    _tokenId,
                    data
                )
            );
            require(success && (returnData.length == 0 || abi.decode(returnData, (bytes4)) == MAGIC_ON_ERC721_RECEIVED), "Transfer to non ERC721Receiver implementer");
        }
    }

    ///@dev The zero address indicates there is no approved address.
    ///  Throws unless `msg.sender` is the current NFT owner, or an authorized
    ///  operator of the current owner.
    function approve(address _approved, uint256 _tokenId) external payable override {
        // Check if the token exists
        require(idToOwner[_tokenId] != address(0), "Token does not exist");
        // Check if the sender is the owner of the token
        address owner = idToOwner[_tokenId];
        require(operatorApprovals[owner][msg.sender] || owner == msg.sender, "Not authorized to approve");
        // Emit the Approval event
        emit Approval(owner, _approved, _tokenId);
    }

    /// @notice Enable or disable approval for a third party ("operator") to manage
    function setApprovalForAll(address _operator, bool _approved) external override {
        require(_operator != msg.sender, "Cannot approve to self");
        // Set operator approval
        operatorApprovals[msg.sender][_operator] = _approved;
        // Emit event
        emit ApprovalForAll(msg.sender, _operator, _approved);
    }

    /// @notice Get the approved address for a single NFT
    function getApproved(uint256 _tokenId) external view override returns (address) {
        // Return the approved address for the token
        if (idToOwner[_tokenId] == address(0)) {
            return address(0); // Token does not exist
        }
        return idToOwner[_tokenId];
    }

    /// @notice Query if an address is an authorized operator for another address
    function isApprovedForAll(address _owner, address _operator) external view override returns (bool) {
        // Check if the operator is approved for all
        if (operatorApprovals[_owner][_operator]) {
            return true;
        }
        return false; // Placeholder, as we don't store approvals in this simple implementation
    }

}