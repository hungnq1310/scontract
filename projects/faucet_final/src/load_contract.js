import { ethers } from "ethers";

export const loadContract = async (name, provider) => {
    const res = await fetch(`/contracts/${name}.json`);
    const artifact = await res.json();

    const abi = artifact.abi;
    const networkId = Object.keys(artifact.networks)[0]; // or use "5777" for Ganache
    const address = artifact.networks[networkId].address;
    
    const signer = await provider.getSigner();

    return new ethers.Contract(address, abi, signer);
}
