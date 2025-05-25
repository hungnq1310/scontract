import { useState, useEffect } from 'react';
import './App.css';
import Web3 from 'web3';
import detectEthereumProvider from '@metamask/detect-provider';

function App() {
  
  const [web3Api, setWeb3Api] = useState({
    provider: null,
    web3: null,
  })

  const [account, setAccount] = useState(null);

  useEffect(() => {
    const loadProvider = async () => {
      const provider = await detectEthereumProvider();

      if (provider) {
        provider.request({ method: 'eth_requestAccounts' })
        setWeb3Api({
          provider,
          web3: new Web3(provider)
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

  return (
    <div className='faucet-wrapper'>
      <div className='faucet'>
        <div className='balance-view is-size-2'>
          Current balance: <strong>10 ETH</strong>
        </div>
        <button className='button is-primary mr-5'>Donate</button>
        <button className='button is-primary'>Withdraw</button>
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
 