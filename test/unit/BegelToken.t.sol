// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Test, console} from "forge-std/Test.sol";
import {BegelToken} from "../../src/BegelToken.sol";

contract BegelTokenTest is Test {
    BegelToken public token;
    address public user = makeAddr("USER");

    function setUp() public {
        token = new BegelToken();
    }

    function test_Constructor() public view {
        assertEq(token.name(), "Begel Token");
        assertEq(token.symbol(), "BT");
        assertEq(token.totalSupply(), 0);
        assertEq(token.owner(), address(this));
    }

    function test_MintAsOwner() public {
        uint256 amount = 1000;
        token.mint(user, amount);

        assertEq(token.balanceOf(user), amount);
        assertEq(token.totalSupply(), amount);
    }

    function test_MintToZeroAddress() public {
        uint256 amount = 1000;
        vm.expectRevert();
        token.mint(address(0), amount);
    }

    function test_NonOwnerCannotMint() public {
        uint256 amount = 1000;
        vm.prank(user);
        vm.expectRevert();
        token.mint(user, amount);
    }

    function test_Transfer() public {
        uint256 amount = 1000;
        address recipient = address(0x2);

        // First mint some tokens to our test contract
        token.mint(address(this), amount);

        // Then transfer to recipient
        bool success = token.transfer(recipient, amount);

        assertTrue(success);
        assertEq(token.balanceOf(recipient), amount);
        assertEq(token.balanceOf(address(this)), 0);
    }

    function test_FailTransferInsufficientBalance() public {
        uint256 amount = 1000;
        address recipient = address(0x2);

        vm.expectRevert();
        // Try to transfer without having tokens
        token.transfer(recipient, amount);
    }
}
