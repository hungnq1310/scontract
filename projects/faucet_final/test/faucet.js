const Faucet = artifacts.require("Faucet");

contract("Faucet", () => {
    it("should deploy the Faucet contract", async () => {
        const faucetInstance = await Faucet.deployed();
        assert(faucetInstance, "Faucet contract was not deployed successfully");
        assert(faucetInstance.address, "Faucet contract address is not set");
    });
})

contract("Faucet", () => {
    it("should add funds to the faucet", async () => {
        const faucetInstance = await Faucet.deployed();
        const initialBalance = await web3.eth.getBalance(faucetInstance.address);
        
        // Send 1 ether to the faucet
        await faucetInstance.addFunds({ value: web3.utils.toWei("1", "ether") });
        
        const newBalance = await web3.eth.getBalance(faucetInstance.address);
        assert(newBalance, web3.utils.toWei("1", "ether"), "Faucet balance should be 1 ether");
    });
})