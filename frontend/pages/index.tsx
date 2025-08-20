import { useAccount } from "wagmi";
import { ConnectButton } from "@rainbow-me/rainbowkit";
import Dashboard from "../components/Dashboard";

export default function Home() {
  const { address, isConnected } = useAccount();

  return (
    <div>
      <h1>KYCLESS CAPITAL</h1>
      <ConnectButton />
      {isConnected ? <Dashboard address={address} /> : <p>Connect your wallet to start</p>}
    </div>
  );
}