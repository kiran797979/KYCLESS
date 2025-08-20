import { useState } from "react";
import { useContractWrite, usePrepareContractWrite } from "wagmi";
import LendingPoolABI from "../abi/LendingPool.json";
import { polygonMumbai } from "wagmi/chains";

const poolAddress = "0xYOUR_DEPLOYED_POOL_ADDRESS"; // Replace with deployed address

export default function LendingActions({ address }) {
  const [depositAmount, setDepositAmount] = useState("");
  const [borrowAmount, setBorrowAmount] = useState("");
  const [collateral, setCollateral] = useState("");
  const [stake, setStake] = useState("");
  const [minScore, setMinScore] = useState("");
  const [zkProof, setZkProof] = useState("");

  // Deposit
  const { config: depositConfig } = usePrepareContractWrite({
    address: poolAddress,
    abi: LendingPoolABI,
    functionName: "deposit",
    chainId: polygonMumbai.id,
    args: [depositAmount],
  });
  const { write: deposit } = useContractWrite(depositConfig);

  // Borrow
  const { config: borrowConfig } = usePrepareContractWrite({
    address: poolAddress,
    abi: LendingPoolABI,
    functionName: "borrow",
    chainId: polygonMumbai.id,
    args: [borrowAmount, collateral, stake, minScore, zkProof],
  });
  const { write: borrow } = useContractWrite(borrowConfig);

  // Repay
  const { config: repayConfig } = usePrepareContractWrite({
    address: poolAddress,
    abi: LendingPoolABI,
    functionName: "repay",
    chainId: polygonMumbai.id,
    args: [],
  });
  const { write: repay } = useContractWrite(repayConfig);

  return (
    <div>
      <h2>Lending & Borrowing</h2>
      <div>
        <input
          type="text"
          placeholder="Deposit Amount"
          value={depositAmount}
          onChange={(e) => setDepositAmount(e.target.value)}
        />
        <button onClick={() => deposit?.()}>Deposit ERC20</button>
      </div>
      <div>
        <input
          type="text"
          placeholder="Borrow Amount"
          value={borrowAmount}
          onChange={(e) => setBorrowAmount(e.target.value)}
        />
        <input
          type="text"
          placeholder="Collateral"
          value={collateral}
          onChange={(e) => setCollateral(e.target.value)}
        />
        <input
          type="text"
          placeholder="Stake Governance"
          value={stake}
          onChange={(e) => setStake(e.target.value)}
        />
        <input
          type="text"
          placeholder="Min Score"
          value={minScore}
          onChange={(e) => setMinScore(e.target.value)}
        />
        <input
          type="text"
          placeholder="zkProof"
          value={zkProof}
          onChange={(e) => setZkProof(e.target.value)}
        />
        <button onClick={() => borrow?.()}>Borrow</button>
      </div>
      <div>
        <button onClick={() => repay?.()}>Repay</button>
      </div>
    </div>
  );
}