import React, { useEffect, useState } from 'react';
import { ethers } from 'ethers';
import KryptoBird from '../abis/KryptoBird.json';
import detectEthereumProvider from '@metamask/detect-provider';
import Web3 from 'web3';
import {
  MDBCard,
  MDBCardBody,
  MDBCardTitle,
  MDBCardText,
  MDBCardImage,
  MDBBtn,
} from 'mdb-react-ui-kit';
import './App.css';

export default function App() {
  const [address, setAddress] = useState();
  const [balance, setBalance] = useState();
  const [contract, setContract] = useState(null);
  const [totalSupply, setTotalSupply] = useState(0);
  const [kryptoBirdz, setkryptoBirdz] = useState([]);

  const [inputFile, setInputFile] = useState('');

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
      const getContract = new web3.eth.Contract(abi, address);
      setContract({ contract: getContract });

      // call the total supply of our Krypto bird
      const supply = await getContract.methods.totalSupply.call();
      setTotalSupply(supply);

      // set up an array to keep track of tokens
      // load kryptobirdz
      for (let i = 0; i < supply; i++) {
        const KryptoBird = await getContract.methods.kryptoBirdz(i).call();
        setkryptoBirdz((state) => [...state, KryptoBird]);
      }
    } else {
      window.alert('Smart contract not deployed');
    }
  };

  const mint = (bird) => {
    contract.contract.methods
      .mint(bird)
      .send({ from: address })
      .once('receipt', (receipt) => {
        setkryptoBirdz((state) => [...state, bird]);
      });
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
      <div className='container-filled'>
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

        <div className='container-fluid mt-1'>
          <div className='row'>
            <main role='main' className='col-lg-12 d-flex text-center'>
              <div
                className='content mr-auto ml-auto'
                style={{ opacity: '0.8' }}>
                <h1 style={{ color: 'black' }}>
                  KryptoBirdz - NFT Marketplace
                </h1>
                <form
                  onSubmit={(e) => {
                    e.preventDefault();
                    mint(inputFile);
                  }}>
                  <input
                    placeholder='Add file location'
                    required
                    type='text'
                    className='form-control mb-1'
                    value={inputFile}
                    onChange={(e) => setInputFile(e.target.value)}
                  />
                  <button
                    type='submit'
                    style={{ margin: '6px' }}
                    className='btn btn-primary btn-black'>
                    MINT
                  </button>
                </form>
              </div>
            </main>
          </div>
          <hr></hr>
          <div className='row textCenter'>
            {kryptoBirdz.map((kryptoBird, key) => {
              return (
                <div>
                  <div>
                    <MDBCard
                      className='token img'
                      style={{ maxWidth: '22rem' }}>
                      <MDBCardImage
                        src={kryptoBird}
                        position='top'
                        style={{ marginRight: '4px' }}
                        height='250rem'
                      />
                      <MDBCardBody>
                        <MDBCardTitle>KryptoBirdz</MDBCardTitle>
                        <MDBCardText>
                          The KryptoBirdz are 20 uniquely generated KBirdz from
                          the cyperpunk clound galaxy Mystopia. There is only
                          one bird of each type on the etherium block change
                        </MDBCardText>
                        <MDBBtn href={kryptoBird}>Download</MDBBtn>
                      </MDBCardBody>
                    </MDBCard>
                  </div>
                </div>
              );
            })}
          </div>
        </div>
      </div>
    </>
  );
}

// https://i.ibb.co/xCrZb9F/k1.png
// https://i.ibb.co/zrHDzc9/k2.png
// https://i.ibb.co/9G1ywBw/k3.png
// https://i.ibb.co/bmZnXHC/k4.png
// https://i.ibb.co/KNY8dCX/k5.png
// https://i.ibb.co/zNLxQKn/k6.png
// https://i.ibb.co/pwLNMdm/k7.png
// https://i.ibb.co/gDNcmh1/k8.png
// https://i.ibb.co/gWXX2S8/k9.png
// https://i.ibb.co/ypy5gtp/k10.png
// https://i.ibb.co/cLRtBdy/k11.png
