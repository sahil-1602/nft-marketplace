import React, { useEffect, useState } from 'react';
import { ethers } from 'ethers';
import KryptoBird from '../abis/KryptoBird.json';
import detectEthereumProvider from '@metamask/detect-provider';
import Web3 from 'web3';

export default function App() {
  const [address, setAddress] = useState();
  const [balance, setBalance] = useState();
  //   const [contract, setContract] = useState();

  const connectWalletHandler = () => {
    if (window.ethereum) {
      window.ethereum
        .request({ method: 'eth_requestAccounts' })
        .then(async (result) => {
          const provider = await detectEthereumProvider();
          window.web3 = new Web3(provider);
          loadBlockchainData(result[0]);
        });
    } else {
    }
  };

  const loadBlockchainData = async (newAcc) => {
    setAddress(newAcc);
    getUserBalance(newAcc);

    const web3 = window.web3;
    const networkId = await web3.eth.net.getId();
    const networkData = KryptoBird.networks[networkId];
    if (networkData) {
      const abi = KryptoBird.abi;
      const address = networkData.address;
      const contract = new web3.eth.Contract(abi, address);
      console.log(contract);
      //   setContract(networkData);
    }
  };

  const getUserBalance = (address) => {
    window.ethereum
      .request({ method: 'eth_getBalance', params: [address, 'latest'] })
      .then((balance) => {
        setBalance(ethers.utils.formatEther(balance));
      });
  };

  useEffect(() => {
    connectWalletHandler();
  }, []);

  return (
    <>
      <nav className='navbar navbar-dark fixed-top bg-dark flex-md-nowrap p-0 shadow'>
        <div
          className='navbar-brand col-sm-3 col-md-3 mr-0'
          style={{ color: 'white' }}>
          Krypto Birdz NFTs (Non Fungible Tokens)
        </div>
        <ul className='navbar-nav px-3'>
          <li className='nav-item text-nowrap d-none d-sm-none d-sm-block'>
            <small className='text-white'>{address}</small>
          </li>
        </ul>
      </nav>
    </>
  );
}
