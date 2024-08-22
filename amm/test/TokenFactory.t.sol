// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {TokenFactory} from "../src/TokenFactory.sol";
import {Token} from "../src/Token.sol";

contract TokenFactoryTest is Test {
    TokenFactory public factory;
    Token public myToken;
    address public wallet = vm.envAddress("WALLET_ADDRESS");

    function setUp() public {
        vm.startPrank(wallet);
        factory = new TokenFactory();
        vm.stopPrank();
    }

    function test_getTokenNumber(uint256 supply, string memory name, string memory symbol) public {
        vm.startPrank(wallet);

        assertEq(factory.getTokenNumber(), 0);

        // create a token
        factory.createToken(supply, name, symbol);

        assertEq(factory.getTokenNumber(), 1);
        vm.stopPrank();
    }

    // getTokens returns an array of token addresses
    function test_getTokens(uint256 supply, string memory name, string memory symbol) public {
        assertEq(factory.getTokens().length, 0);
        vm.startPrank(wallet);
        factory.createToken(supply, name, symbol);
        assertEq(factory.getTokens().length, 1);
        vm.stopPrank();
    }

    // function test_createToken(uint256 initialSupply, string memory name, string memory symbol) public {
    //     vm.startPrank(myAdd);
    //     factory.createToken(initialSupply, name, symbol);
    //     address[] memory tokens = factory.getTokens();

    //     address add = tokens[0];
    //     myToken = Token(add);

    //     // tests sur le token créé
    //     assertEq(myToken.symbol(), symbol);
    //     assertEq(myToken.name(), name);
    //     assertEq(myToken.totalSupply(), initialSupply);
    //     assertEq(myToken.balanceOf(address(factory)), initialSupply);
    //     assertEq(myToken.decimals(), 18);

    //     // test supply stored on mapping tokenToSupply
    //     assertEq(factory.getSupply(add), initialSupply);
    //     assertEq(factory.getTokenNumber(), 1);
    //     vm.stopPrank();
    // }

    function test_getSupply(uint256 supply, string memory name, string memory symbol) public {
        vm.startPrank(wallet);

        // create a token and get its address
        factory.createToken(supply, name, symbol);
        address tokenAddress = factory.getTokens()[0];

        assertEq(factory.getSupply(tokenAddress), supply);
        assertEq(address(factory).balance, 0);
        assertEq(Token(tokenAddress).balanceOf(address(factory)), supply);
        
        vm.stopPrank();
    }

    // function test_getTokenNumber_after() public view {
    //     assertEq(factory.getTokenNumber(), 1);
    // }
}
