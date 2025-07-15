// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Test, console} from "forge-std/Test.sol";
import {MerkleAirdrop} from "../../src/MerkleAirdrop.sol";
import {BegelToken} from "../../src/BegelToken.sol";
import {DeployMerkleAirdrop} from "../../script/DeployMerkleAirdrop.s.sol";
import {ZkSyncChainChecker} from "lib/foundry-devops/src/ZkSyncChainChecker.sol";

contract MerkleAirdropTest is ZkSyncChainChecker, Test {
    MerkleAirdrop public merkleAirdrop;
    BegelToken public begelToken;

    bytes32 public root = 0xaa5d581231e596618465a56aa0f5870ba6e20785fe436d5bfb82b08662ccc7c4;

    address gasPayer;
    address user;
    uint256 userPrivKey;

    uint256 public AMOUNT = 25 * 1e18;
    uint256 public AMOUNT_ON_AIRDROP = 100 * 1e18;
    bytes32[] public PROOF = [
        bytes32(0x0fd7c981d39bece61f7499702bf59b3114a90e66b51ba2c53abdf7b62986c00a),
        bytes32(0xe5ebd1e1b5a5478a944ecab36a9a954ac3b6b8216875f6524caa7a1d87096576)
    ];

    function setUp() public {
        if (!isZkSyncChain()) {
            DeployMerkleAirdrop deployer = new DeployMerkleAirdrop();
            (merkleAirdrop, begelToken) = deployer.deployMerkleAirdrop();
        } else {
            begelToken = new BegelToken();
            merkleAirdrop = new MerkleAirdrop(root, begelToken);
            begelToken.mint(begelToken.owner(), AMOUNT_ON_AIRDROP);
            begelToken.transfer(address(merkleAirdrop), AMOUNT_ON_AIRDROP);
        }
        (user, userPrivKey) = makeAddrAndKey("user");
        gasPayer = makeAddr("GASPAYER");
    }

    function test_UsersCanClaim() public {
        uint256 startingBal = begelToken.balanceOf(user);
        bytes32 digest = merkleAirdrop.getMessage(user, AMOUNT);

        (uint8 v, bytes32 r, bytes32 s) = vm.sign(userPrivKey, digest);

        vm.prank(gasPayer);
        merkleAirdrop.claim(user, AMOUNT, PROOF, v, r, s);

        uint256 endingBal = begelToken.balanceOf(user);
        console.log("Ending Balance", endingBal);
        assertEq(startingBal, endingBal - AMOUNT);
    }
}
