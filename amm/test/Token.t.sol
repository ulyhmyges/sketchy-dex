// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {TokenFactory} from "../src/TokenFactory.sol";
import {Token} from "../src/Token.sol";

contract TokenFactoryTest is Test {
    Token public myToken;

    address public wallet = vm.envAddress("WALLET_ADDRESS");

    function setUp() public {
        vm.startPrank(wallet);
        myToken = new Token(45, "myToken", "TK", wallet);
        vm.stopPrank();
    }

    function test_token() public {
        assertEq(myToken.name(), "myToken");
        assertEq(myToken.symbol(), "TK");
        assertEq(myToken.totalSupply(), 45);
        assertEq(myToken.decimals(), 18);
        assertEq(myToken.balanceOf(wallet), 45);
        // DefaultSender: 0x1804c8AB1F12E6bbf3894d4083f33e07309d1f38
        assertEq(myToken.balanceOf(msg.sender), 0);
        vm.startPrank(wallet);
        myToken.transfer(0x1804c8AB1F12E6bbf3894d4083f33e07309d1f38, 10);
        assertEq(myToken.balanceOf(0x1804c8AB1F12E6bbf3894d4083f33e07309d1f38), 10);
        vm.stopPrank();
        
        // my balance after transfer operation
        assertEq(myToken.balanceOf(wallet), 35);
    }
}
