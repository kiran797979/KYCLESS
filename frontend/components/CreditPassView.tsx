import { useEffect, useState } from "react";
import NFTCreditPassABI from "../abi/NFTCreditPass.json";
import { useContractRead } from "wagmi";

const passAddress = "0xYOUR_CREDIT_PASS_ADDRESS"; // Replace with deployed address

export default function CreditPassView({ address }) {
  const [tier, setTier] = useState("Bronze");

  const { data: hasPass } = useContractRead({
    address: passAddress,
    abi: NFTCreditPassABI,
    functionName: "hasPass",
    args: [address],
    watch: true,
  });

  // Fetch score & tier from contract
  useEffect(() => {
    // TODO: Read score from Reputation.sol, then getTier from NFTCreditPass.sol
    setTier("Bronze"); // Demo: static
  }, [address]);

  return (
    <div>
      <h3>Your Credit Pass: {tier}</h3>
      {hasPass ? <span>✅ NFT Minted</span> : <span>❌ Mint on deposit</span>}
      {/* Display NFT image/metadata from IPFS */}
    </div>
  );
}