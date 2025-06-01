import { useState, useEffect } from 'react';
import './App.css';
import Web3 from 'web3';
import detectEthereumProvider from '@metamask/detect-provider';

import { loadContract } from './load_contract';

function App() {
  
  const [web3Api, setWeb3Api] = useState({
    provider: null,
    web3: null,
  })

  const [account, setAccount] = useState(null);

  const [contract, setContract] = useState(null);


  useEffect(() => {
    const loadProvider = async () => {
      const provider = await detectEthereumProvider();

      debugger;

      if (provider) {
        setWeb3Api({
          provider,
          web3: new Web3(provider),
        });
      }
      else {
        console.error('Please install MetaMask or another Ethereum provider');
      }
    }
    loadProvider();
  }, []);

  useEffect(() => {
    const getAccount = async () => {
      if (web3Api.web3) {
        const accounts = await web3Api.web3.eth.getAccounts();
        setAccount(accounts[0]);
      }
    }
    web3Api.web3 && getAccount();
  }
  , [web3Api.web3]); 

  useEffect(() => {
    const loadContractData = async () => {
      const contract = await loadContract('Faucet', web3Api.provider);
      debugger;
      setContract(contract);
    }
    loadContractData();
  }, [web3Api.web3]);
  

  return (
    <div className='faucet-wrapper'>
      <div className='faucet'>
        <div className='balance-view is-size-2'>
          Current balance: <strong>10 ETH</strong>
        </div>
        <button className='button is-primary mr-5'>Donate</button>
        <button className='button is-danger mr-5'>Withdraw</button>
        <button className='button is-link mr-5'
          onClick={async () => {
            web3Api.provider.request({ method: 'eth_requestAccounts' })
          }}
        >
          Connect Wallet
        </button>
        <div>
          <span>
            <strong>Account Address: </strong>
            {
              account ? account : 'Account not connected'
            }
          </span>
        </div>

      </div>
    </div>
  );
}

export default App;
 