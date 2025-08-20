const { execSync } = require("child_process");
const fs = require("fs");

async function generateProof(userAddress, score, minScore) {
    const input = { user: userAddress, score, minScore };
    fs.writeFileSync("circuits/input.json", JSON.stringify(input));

    execSync("circom circuits/reputation.circom --r1cs --wasm --sym -o circuits/");
    execSync("node circuits/reputation_js/generate_witness.js circuits/reputation_js/reputation.wasm circuits/input.json circuits/witness.wtns");
    execSync("snarkjs groth16 prove circuits/reputation_final.zkey circuits/witness.wtns circuits/proof.json circuits/public.json");

    const proof = JSON.parse(fs.readFileSync("circuits/proof.json"));
    return proof;
}

// Usage: node backend/generateZKProof.js <userAddress> <score> <minScore>
if (require.main === module) {
    const [userAddress, score, minScore] = process.argv.slice(2);
    generateProof(userAddress, Number(score), Number(minScore)).then((proof) => {
        console.log(JSON.stringify(proof, null, 2));
    });
}