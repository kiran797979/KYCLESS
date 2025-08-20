# KYCLESS CAPITAL — Step-by-Step Deployment Guide

This guide will help you deploy the entire project (contracts, frontend, backend, circuits) on the Polygon Mumbai testnet and run the live dApp locally or on the web.

---

## 1. Prerequisites

- Node.js (v18+ recommended)
- Yarn or npm
- MetaMask (or other EVM wallet)
- Mumbai testnet ETH for gas (get from [Polygon Faucet](https://faucet.polygon.technology/))
- Install [Hardhat](https://hardhat.org/), [Circom](https://docs.circom.io/getting-started/installation/), [snarkjs](https://github.com/iden3/snarkjs), and [IPFS CLI](https://docs.ipfs.tech/install/cli/)

---

## 2. Clone the Repo & Install Dependencies

```bash
git clone https://github.com/kiran797979/KYCLESS.git
cd KYCLESS

# Install dependencies for all packages
yarn install

# Install contract dependencies
cd contracts
yarn install

# Install frontend dependencies
cd ../frontend
yarn install

# Install backend dependencies
cd ../backend
yarn install
```

---

## 3. Compile & Deploy Smart Contracts (Polygon Mumbai)

Update contract addresses as needed in the frontend code.

**Set your Mumbai RPC and private key in `hardhat.config.js`.**

```js
// Example snippet for hardhat.config.js
module.exports = {
  networks: {
    mumbai: {
      url: "https://rpc-mumbai.maticvigil.com",
      accounts: ["0xYOUR_PRIVATE_KEY"]
    }
  },
  solidity: "0.8.20"
};
```

**Compile and deploy:**

```bash
cd ../contracts
npx hardhat compile
npx hardhat run scripts/deploy.js --network mumbai
```

_Note: The deploy script should deploy LendingPool, Reputation, NFTCreditPass, and GovernanceToken. Save/print the deployed addresses!_

---

## 4. Set Up zk-SNARK Circuits

```bash
cd ../circuits
# Compile the circuit
circom reputation.circom --r1cs --wasm --sym -o .
# Generate trusted setup (Groth16)
snarkjs groth16 setup reputation.r1cs pot12_final.ptau reputation_final.zkey
```

---

## 5. Backend: Generate zk-Proofs

```bash
cd ../backend
# Example usage (after contracts deployed and circuit compiled)
node generateZKProof.js <userAddress> <score> <minScore>
# This outputs proof.json to be used in frontend/contract calls
```

---

## 6. Upload NFT Metadata to IPFS/Arweave

- Create metadata JSON for each tier (Bronze, Silver, Gold, Diamond) with images.
- Upload to IPFS using CLI or [web uploader](https://nft.storage/).
- Update URIs in `NFTCreditPass.sol` contract.

---

## 7. Configure Frontend

- Update deployed contract addresses in `frontend/components/LendingActions.tsx`, `CreditPassView.tsx`, and ABI files.
- Update RPC and chain settings if needed.

---

## 8. Run the Frontend dApp

```bash
cd ../frontend
yarn dev
# Visit http://localhost:3000 in your browser
```

---

## 9. Test the Full Lifecycle

1. **Connect Wallet:**  
   Use RainbowKit to connect MetaMask.
2. **Deposit:**  
   Deposit ERC20 tokens into the lending pool.
3. **Borrow:**  
   Generate zk-proof with backend, supply it along with collateral and stake.
4. **Repay:**  
   Repay the loan, watch your NFT Credit Pass tier upgrade.
5. **Default:**  
   Optionally, call `checkDefault` to test slashing and lender reward.
6. **View Stats:**  
   See pool stats and your credit pass in the dashboard.

---

## 10. Optional: Deploy Frontend on Vercel/Netlify

- Push your frontend code to GitHub.
- Connect to [Vercel](https://vercel.com/) or [Netlify](https://netlify.com/), set environment variables (RPC, contract addresses).
- Deploy!

---

## 11. Troubleshooting

- If contract calls fail: check Mumbai balances, contract addresses, ABI, and RPC.
- If zk-proof fails: check backend circuit compilation and input values.
- For NFT images not showing: verify IPFS URIs in the contract and metadata.
- For frontend issues: check browser console and Wagmi/RainbowKit configs.

---

## 12. Resources

- [Polygon Mumbai Faucet](https://faucet.polygon.technology/)
- [Circom Docs](https://docs.circom.io/)
- [snarkjs Docs](https://github.com/iden3/snarkjs)
- [Wagmi Docs](https://wagmi.sh/)
- [RainbowKit Docs](https://www.rainbowkit.com/docs/introduction)

---

**You’re live! Share your Mumbai address and contract addresses for others to try your hackathon dApp.**