# KYCLESS CAPITAL

Decentralized capital market for lending/borrowing **without KYC** using smart contracts, zk-SNARK reputation proofs, and NFT credit passes.

## Architecture

- **Smart Contracts**: LendingPool, Reputation tracking, NFT Credit Pass, GovernanceToken
- **Frontend**: Next.js, Wagmi, RainbowKit
- **zk-SNARK**: Circom circuits, snarkjs proofs
- **Backend**: Node.js scripts for off-chain proof generation
- **Storage**: Credit Pass metadata on IPFS/Arweave

## Features

- **Deposit, Borrow, Repay, Stake** (no KYC)
- **Dynamic interest rates, slashing on default**
- **zk-Proof of repayment score**
- **Soulbound NFT Credit Pass (Bronze → Diamond)**
- **Demo Mode: Polygon Mumbai, test tokens, simulated loan lifecycle**

## Quick Demo

1. **Clone repo & install dependencies**
    ```bash
    yarn install  # or npm install
    cd contracts && yarn install
    cd frontend && yarn install
    cd backend && yarn install
    ```

2. **Deploy contracts to Mumbai**
    ```bash
    npx hardhat run scripts/deploy.js --network mumbai
    ```

3. **Run frontend**
    ```bash
    cd frontend
    yarn dev
    ```

4. **Generate zk-proof for reputation**
    ```bash
    node backend/generateZKProof.js <yourAddress> <score> <minScore>
    ```

5. **Test: Deposit, Borrow, Repay, upgrade NFT tier**

## File Structure

- `/contracts` – Solidity smart contracts
- `/frontend` – Next.js dApp
- `/backend` – Node.js zk-proof scripts
- `/circuits` – Circom zk-SNARK circuits
- `/docs` – Documentation

## Extend & Hack

- Add more pool types, advanced interest rate logic
- Plug in new zk-circuits for richer reputation
- Use Arweave for permanent storage

## Authors

Built with ❤️ for hackathons. Fork, extend, and build for a truly decentralized future!