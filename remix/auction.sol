// SPDX-License-Identifier: MIT
pragma solidity 0.8.30;


contract Auction {

    // Vars
    uint public auctionEndTime;
    uint public highestBid;
    address public highestBidder;
    bool public ended;
    address payable public beneficiary;
    mapping(address => uint) public pendingReturns;

    event highestBidIncreased(address bidder, uint amount);
    event auctionEnded(address winner, uint amount);

    // Constructor
    constructor(uint _biddingTime, address payable _beneficiary) {
        beneficiary = _beneficiary;
        auctionEndTime = block.timestamp + _biddingTime;
    }

    // Funcs
    function  bid() public payable {
        if (block.timestamp > auctionEndTime) {
            revert("Auction has ended");
        }
        if (msg.value <= highestBid) {
            revert("Bid must be higher than current highest bid");
        }
        if (highestBid != 0) {
            pendingReturns[highestBidder] += highestBid;
        }
        highestBidder = msg.sender;
        highestBid = msg.value;
        emit highestBidIncreased(msg.sender, msg.value);
    }

    function withdraw() public  returns (bool) {
        uint pendingAmount = pendingReturns[msg.sender];
        if (pendingAmount > 0) {
            pendingReturns[msg.sender] = 0;
            if (!payable(msg.sender).send(pendingAmount)) {
                pendingReturns[msg.sender] = pendingAmount;
                return false;
            }
        }
        return true;
    }

    function auctionEnd() public {
        if (block.timestamp < auctionEndTime) {
            revert("Auction has not ended yet");
        }
        if (ended) {
            revert("Auction has already ended");
        }
        
        ended = true;
        emit auctionEnded(highestBidder, highestBid);
        // Transfer the highest bid to the auctioneer
        beneficiary.transfer(highestBid);        

    }

    

}