pragma circom 2.0.0;

template ReputationCheck() {
    signal input score;
    signal input minScore;
    signal output pass;

    // pass = 1 if score >= minScore
    pass <== score >= minScore;
}

component main = ReputationCheck();