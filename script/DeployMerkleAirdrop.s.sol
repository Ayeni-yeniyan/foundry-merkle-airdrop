// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Script} from "forge-std/Script.sol";
import {MerkleAirdrop} from "src/MerkleAirdrop.sol";
import {BegelToken} from "src/BegelToken.sol";

// Merkle tree input file generator script
contract DeployMerkleAirdrop is Script {
    bytes32 public root = 0xaa5d581231e596618465a56aa0f5870ba6e20785fe436d5bfb82b08662ccc7c4;

    uint256 public AMOUNT = 25 * 1e18;
    uint256 public AMOUNT_TO_CLAIM = 100 * 1e18;

    function run() external {
        deployMerkleAirdrop();
    }

    function deployMerkleAirdrop() public returns (MerkleAirdrop merkleAirdrop, BegelToken begelToken) {
        vm.startBroadcast();
        begelToken = new BegelToken();
        merkleAirdrop = new MerkleAirdrop(root, begelToken);
        begelToken.mint(begelToken.owner(), AMOUNT_TO_CLAIM);
        begelToken.transfer(address(merkleAirdrop), AMOUNT_TO_CLAIM);
        vm.stopBroadcast();
    }
}
