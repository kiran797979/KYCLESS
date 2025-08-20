// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

contract NFTCreditPass is ERC721URIStorage {
    uint256 public tokenId;
    mapping(address => uint256) public userToTokenId;
    mapping(address => bool) public hasPass;

    event PassMinted(address indexed user, uint256 tokenId, string tier);

    constructor() ERC721("KYCLESS Credit Pass", "KCPASS") {}

    function mint(address user) external {
        require(!hasPass[user], "Already has pass");
        tokenId++;
        _mint(user, tokenId);
        hasPass[user] = true;
        userToTokenId[user] = tokenId;
        _setTokenURI(tokenId, _tierURI("Bronze"));
        emit PassMinted(user, tokenId, "Bronze");
    }

    function getTier(uint256 score) public pure returns (string memory) {
        if (score >= 1000) return "Diamond";
        if (score >= 500) return "Gold";
        if (score >= 200) return "Silver";
        return "Bronze";
    }

    function upgradeTier(address user, string memory newTier) external {
        uint256 _tokenId = userToTokenId[user];
        _setTokenURI(_tokenId, _tierURI(newTier));
        emit PassMinted(user, _tokenId, newTier);
    }

    function _tierURI(string memory tier) internal pure returns (string memory) {
        // Replace with real IPFS/Arweave URIs
        if (keccak256(bytes(tier)) == keccak256(bytes("Diamond"))) return "ipfs://diamond-metadata";
        if (keccak256(bytes(tier)) == keccak256(bytes("Gold"))) return "ipfs://gold-metadata";
        if (keccak256(bytes(tier)) == keccak256(bytes("Silver"))) return "ipfs://silver-metadata";
        return "ipfs://bronze-metadata";
    }
}