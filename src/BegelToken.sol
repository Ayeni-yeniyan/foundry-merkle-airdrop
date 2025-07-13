// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;
import {ERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";
import {Ownable} from "lib/openzeppelin-contracts/contracts/access/Ownable.sol";

/// @title Token contract for merkle airdrop
/// @author Ayeni-yeniyan
/// @notice The token can only be minted by the merkle airdrop

contract BegelToken is ERC20, Ownable {
    constructor() ERC20("Begel Token", "BT") Ownable(msg.sender) {}

    function mint(address account, uint256 value) external onlyOwner {
        _mint(account, value);
    }
}
