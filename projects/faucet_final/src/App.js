import { useState, useEffect } from 'react';
import './App.css';
import { ethers } from 'ethers';
import { loadContract, loadProvider } from './load_contract'; // Adjust the path as necessary

function App() {
  const [web3Api, setWeb3Api] = useState({ provider: null });
  const [account, setAccount] = useState(null);
  const [contract, setContract] = useState(null);
  const [balance, setBalance] = useState('0');

  // Load Ethereum provider (MetaMask)
  useEffect(() => {
    const loadProvider2 = async () => {
      const provider = loadProvider(window.ethereum);
      if (provider) {
        setWeb3Api({ provider });
      } else {
        console.error('Please install MetaMask');
      }
    };
    loadProvider2();
  }, []);

  // Connect wallet and fetch account
  useEffect(() => {
    const getAccount = async () => {
      if (web3Api.provider) {
        const signer = await web3Api.provider.getSigner();
        const accountAddress = await signer.getAddress(); 
        setAccount(accountAddress);
      }
    };
    if (web3Api.provider) getAccount();
  }, [web3Api.provider]);

  // Load contract using embedded logic
  useEffect(() => {

    const initContract = async () => {
      if (web3Api.provider) {
        const contractInstance = await loadContract('Faucet', web3Api.provider);
        setContract(contractInstance);
      }
    };

    if (web3Api.provider) initContract();
  }, [web3Api.provider]);

  // Load contract balance
  useEffect(() => {
    const fetchBalance = async () => {
      if (account && web3Api.provider) {

        const balanceWei = await web3Api.provider.getBalance(account);
        const balanceEth = ethers.formatEther(balanceWei);
        setBalance(balanceEth);
      }
    };
    if (account) fetchBalance();
  }, [account, web3Api.provider]);

  // Connect wallet manually
  const connectWallet = async () => {
    try {
      const signer = await web3Api.provider.getSigner();
      const address = await signer.getAddress();
      setAccount(address);
    } catch (err) {
      console.error('Wallet connection failed', err);
    }
  };

  return (
    <div className="faucet-wrapper">
      <div className="faucet">
        <div className="balance-view is-size-2">
          Current balance: <strong>{balance} ETH</strong>
        </div>
        <button className="button is-primary mr-5" onClick={() => console.log('Donate logic here')}>Donate</button>
        <button className="button is-danger mr-5" onClick={() => console.log('Withdraw logic here')}>Withdraw</button>
        <button className="button is-link mr-5" onClick={connectWallet}>
          Connect Wallet
        </button>
        <div>
          <strong>Account Address: </strong>
          {account || 'Account not connected'}
        </div>
      </div>
    </div>
  );
}

export default App;
