const MyContract = artifacts.require("firstcontract");
const myContractDeployedAddress = "0x5077B6145bAC9cC7B5ad2B575b0615E07CC89a83"; // from migration

contract("firstcontract", async (accounts) => {
    it("should deploy the contract", async () => {
        const myContractInstance = await MyContract.deployed();
        assert(myContractInstance.address != "");
    });
});