// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./Reputation.sol";
import "./NFTCreditPass.sol";
import "./GovernanceToken.sol";

contract LendingPool {
    IERC20 public token;
    Reputation public reputation;
    NFTCreditPass public creditPass;
    GovernanceToken public governance;
    address public admin;

    uint256 public totalDeposits;
    uint256 public totalBorrows;
    uint256 public interestRateBase = 5; // 5% base rate

    mapping(address => uint256) public deposits;
    mapping(address => uint256) public borrows;
    mapping(address => uint256) public collateralLocked;
    mapping(address => uint256) public stakeLocked;
    mapping(address => bool) public isBorrowing;

    event Deposited(address indexed user, uint256 amount);
    event Borrowed(address indexed user, uint256 amount, uint256 collateral, uint256 stake);
    event Repaid(address indexed user, uint256 amount);
    event Defaulted(address indexed user, uint256 slashedAmount, uint256 lendersReward);

    constructor(
        address _token,
        address _reputation,
        address _creditPass,
        address _governance
    ) {
        token = IERC20(_token);
        reputation = Reputation(_reputation);
        creditPass = NFTCreditPass(_creditPass);
        governance = GovernanceToken(_governance);
        admin = msg.sender;
    }

    function deposit(uint256 amount) external {
        require(amount > 0, "Deposit > 0");
        token.transferFrom(msg.sender, address(this), amount);
        deposits[msg.sender] += amount;
        totalDeposits += amount;
        emit Deposited(msg.sender, amount);

        if (!creditPass.hasPass(msg.sender)) {
            creditPass.mint(msg.sender);
        }
    }

    function getUtilizationRate() public view returns (uint256) {
        if (totalDeposits == 0) return interestRateBase;
        return interestRateBase + (totalBorrows * 100 / totalDeposits) / 10;
    }

    function borrow(
        uint256 amount,
        uint256 collateral,
        uint256 stakeAmount,
        uint256 minScore,
        uint256 zkProof
    ) external {
        require(!isBorrowing[msg.sender], "Already borrowing");
        require(token.balanceOf(address(this)) >= amount, "Insufficient pool");
        require(reputation.verifyProof(msg.sender, minScore, zkProof), "Reputation proof failed");

        require(token.transferFrom(msg.sender, address(this), collateral), "Collateral failed");
        require(governance.transferFrom(msg.sender, address(this), stakeAmount), "Stake failed");

        borrows[msg.sender] = amount;
        collateralLocked[msg.sender] = collateral;
        stakeLocked[msg.sender] = stakeAmount;
        isBorrowing[msg.sender] = true;
        totalBorrows += amount;

        token.transfer(msg.sender, amount);

        emit Borrowed(msg.sender, amount, collateral, stakeAmount);
    }

    function repay() external {
        uint256 amount = borrows[msg.sender];
        require(isBorrowing[msg.sender] && amount > 0, "No active loan");

        token.transferFrom(msg.sender, address(this), amount);
        borrows[msg.sender] = 0;
        totalBorrows -= amount;
        isBorrowing[msg.sender] = false;

        // Unlock collateral & stake
        token.transfer(msg.sender, collateralLocked[msg.sender]);
        governance.transfer(msg.sender, stakeLocked[msg.sender]);

        reputation.recordRepayment(msg.sender, amount);

        // Upgrade NFT tier if eligible
        uint256 score = reputation.getScore(msg.sender);
        string memory newTier = creditPass.getTier(score);
        creditPass.upgradeTier(msg.sender, newTier);

        emit Repaid(msg.sender, amount);
    }

    function checkDefault(address user) external {
        // For demo: anyone can call. In prod, automate after loan expiry.
        require(isBorrowing[user], "User not borrowing");
        // Simulate default (can be time-based or missed payment)
        borrows[user] = 0;
        isBorrowing[user] = false;
        uint256 slashed = stakeLocked[user];
        stakeLocked[user] = 0;

        // Distribute slashed stake to lenders proportionally
        uint256 reward = slashed;
        governance.transfer(admin, reward); // For demo: admin gets, can split for all depositors

        emit Defaulted(user, slashed, reward);
    }
}