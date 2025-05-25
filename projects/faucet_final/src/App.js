import './App.css';

function App() {
  return (
    <div className='faucet-wrapper'>
      <div className='faucet'>
        <div className='balance-view is-size-2'>
          Current balance: <strong>10 ETH</strong>
        </div>
        <div className='button is-primary mr-5'>Donate</div>
        <div className='button is-primary'>Withdraw</div>
      </div>
    </div>
  );
}

export default App;
 