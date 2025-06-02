import { useState, useEffect, useCallback } from 'react';
import './App.css';
import { ethers } from 'ethers';
import { loadContract } from './load_contract'; // Adjust the path as necessary

function App() {
  const [web3Api, setWeb3Api] = useState({ provider: null });
  const [account, setAccount] = useState(null);
  const [contract, setContract] = useState(null);
  const [balance, setBalance] = useState('0');
  const [shouldReload, setShouldReload] = useState(false);
  const realoadEffect = () => {
    setShouldReload(!shouldReload);
  };

  const setAccountListener = () => {
    if (window.ethereum) {
      window.ethereum.on('accountsChanged', (accounts) => {
        setAccount(accounts[0]);
      });
    }
  };

  // Load Ethereum provider (MetaMask)
  useEffect(() => {
    const loadProvider = async () => {
      if (!window.ethereum) {
        console.error('MetaMask is not installed');
        return;
      }
      const provider = new ethers.BrowserProvider(window.ethereum);
      if (provider) {
        setAccountListener(provider);
        setWeb3Api({ provider });
      } else {
        console.error('Failed to load provider');
      }
    };
    loadProvider();
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
  }, [contract, web3Api.provider]);

  // Load contract balance
  useEffect(() => {
    const fetchBalance = async () => {
      if (account) {
        const balanceWei = await web3Api.provider.getBalance(account);
        const balanceEth = ethers.formatEther(balanceWei);
        setBalance(balanceEth);
      }
    };
    fetchBalance();
  }, [account, web3Api.provider, shouldReload]);

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

  // add donate
  const donate = useCallback(async () => {
    try {
      await contract.addFunds( {
        from : account,
        value: ethers.parseEther('1') // Adjust the amount as needed
      });
      realoadEffect();
    }
    catch (err) {
      console.error('Donation failed', err);
    }
  }, [web3Api.provider, account])

  // add withdraw
  const withdraw = useCallback(async () => {
    try {
      await contract.withdraw(ethers.parseEther('1'), { from: account }); // Adjust the amount as needed
      realoadEffect();
    } catch (err) {
      console.error('Withdrawal failed', err);
    }
  }, [web3Api.provider, account]);

  return (
    <div className="faucet-wrapper">
      <div className="faucet">
        <div className="balance-view is-size-2">
          Current balance: <strong>{balance} ETH</strong>
        </div>
        <button className="button is-primary mr-5" onClick={donate}>
          Donate
        </button>
        <button className="button is-danger mr-5" onClick={withdraw}>
          Withdraw
        </button>
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
