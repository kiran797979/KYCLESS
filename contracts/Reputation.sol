// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Reputation {
    mapping(address => uint256) public scores;

    event ScoreUpdated(address indexed user, uint256 score);

    function recordRepayment(address user, uint256 amount) external {
        scores[user] += amount;
        emit ScoreUpdated(user, scores[user]);
    }

    function verifyProof(address user, uint256 minScore, uint256 zkProof) external pure returns (bool) {
        // TODO: Integrate with actual zk-SNARK verifier
        // For demo: always true if zkProof > 0
        return zkProof > 0;
    }

    function getScore(address user) external view returns (uint256) {
        return scores[user];
    }
}