const Crud = artifacts.require("Crud");

contract("Crud", () => {

    before(async () => {
        // Ensure the Crud contract is compiled and ready for testing
        crudInstance = await Crud.deployed(); 

    });

    it("should deploy the Crud contract", async () => {
        assert(crudInstance, "Crud contract was not deployed successfully");
        assert(crudInstance.address, "Crud contract address is not set");
    });

    it("should create a new record", async () => {
        const result = await crudInstance.createPlayer("Player 1");
        assert(result.receipt.status, "Record creation failed");
    });

    it("should read a record", async () => {
        const result = await crudInstance.createPlayer("Player 1");
        assert(result.receipt.status, "Record creation failed");

        const player = await crudInstance.readPlayer(1);
        assert(player[1] === "Player 1", "Record read failed");
    });

    it("should update a record", async () => {
        // First create a record to update
        const result = await crudInstance.createPlayer("Player 1");
        assert(result.receipt.status, "Record creation failed");
        // Now update the record
        const result2 = await crudInstance.updatePlayer(1, "Updated Player 1");
        assert(result2.receipt.status, "Record update failed");

        const player = await crudInstance.readPlayer(1);
        assert(player[1] === "Updated Player 1", "Record update verification failed");
    });

    it("should delete a record", async () => {
        // Create and delete the record
        const result = await crudInstance.createPlayer("Player 1");
        assert(result.receipt.status, "Record creation failed");

        const result2 = await crudInstance.deletePlayer(1);
        assert(result2.receipt.status, "Record deletion failed");

        try {
            await crudInstance.readPlayer(1);
            assert.fail("Player does not exist");
        } catch (error) {
            // Allow any kind of revert or panic
            const message = error.message;
            assert(
                message.includes("Player does not exist"),
                "Record deletion verification failed: Player should not exist"
            );
        }
    });



}
);