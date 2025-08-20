import LendingActions from "./LendingActions";
import CreditPassView from "./CreditPassView";
import PoolStats from "./PoolStats";

export default function Dashboard({ address }) {
  return (
    <div>
      <LendingActions address={address} />
      <CreditPassView address={address} />
      <PoolStats />
    </div>
  );
}