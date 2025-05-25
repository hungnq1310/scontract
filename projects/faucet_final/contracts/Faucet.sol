// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;


contract Faucet {

    // Vars
    uint256 public numOfFunders;
    mapping(uint256 => address) public idxfunders; 
    mapping(address => bool) public funders; // Mapping to track funders

    // addfunds, withdraw, addressindex, getFunders
    function addFunds() external payable {
        // Function to add funds to the faucet
        // This function allows anyone to send Ether to the faucet
        address funder = msg.sender;
        if (!funders[funder]) {
            // If the funder is not already in the funders mapping, add them
            funders[funder] = true;
            idxfunders[numOfFunders] = funder; 
            numOfFunders++;
        }

    }


    receive() external payable {

    }
    
    function getFundersIndex(uint256 index) external view returns (address) {
        // Function to get the address of a funder by index
        // This function allows anyone to retrieve the address of a funder by their index in the funders array
        require(index < numOfFunders, "Index out of bounds");
        return idxfunders[index];
    }

    function getAllFunders() external view returns (address[] memory) {
        // Function to get all funders
        // This function returns an array of all funders' addresses
        address[] memory allFunders = new address[](numOfFunders);
        for (uint256 i = 0; i < numOfFunders; i++) {
            allFunders[i] = idxfunders[i];
        }
        return allFunders;
    }

    modifier limitedWithdraw(uint256 amount) {
        // Modifier to limit the withdrawal amount
        // This modifier ensures that the withdrawal amount does not exceed a certain limit
        require(amount <= 1*(10**18), "Withdrawal amount exceeds 1 Ether");
        _;
    }
    
    function withdraw(uint256 amount) external limitedWithdraw(amount) {
        // Function to withdraw funds from the faucet
        // This function allows anyone to withdraw a specified amount of Ether from the faucet
        require(amount <= address(this).balance, "Insufficient balance in faucet");
        payable(msg.sender).transfer(amount);
    }


}
 