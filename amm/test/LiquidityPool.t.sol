// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {TokenFactory} from "../src/TokenFactory.sol";
import {Token} from "../src/Token.sol";
import {LiquidityPool} from "../src/LiquidityPool.sol";

contract LiquidityPoolTest is Test {
    TokenFactory public tk;
    address public addrA;
    address public addrB;
    LiquidityPool public lp;

    address public wallet = vm.envAddress("WALLET_ADDRESS");

    function setUp() public {
        vm.startPrank(wallet);

        tk = new TokenFactory();
        tk.createToken(500, "TokenA", "TA");
        tk.createToken(300, "TokenB", "TB");
        addrA = tk.getTokens()[0];
        addrB = tk.getTokens()[1];

        lp = new LiquidityPool(addrA, addrB);
        vm.stopPrank();
        //lp = new LiquidityPool(addrA, addrB);

    }

    function test_TokenNumber() public {
        vm.startPrank(wallet);
        assertEq(tk.getTokenNumber(), 2);
        vm.stopPrank();
    }

    function test_addLiquidity() public {
        //vm.startPrank(address(tk));
        vm.startPrank(wallet);
        console.log(Token(addrA).balanceOf(wallet));
        console.log(Token(addrB).balanceOf(wallet));

        Token(addrA).approve(address(lp), 7);
        Token(addrB).approve(address(lp), 50);
        uint256 lpNumber = lp.addLiquidity(7, 50);
        assertEq(lpNumber, 57);
        vm.stopPrank();
    }

    function test_getReserves() public {
        vm.startPrank(wallet);

        // addLiquidity
        Token(addrA).approve(address(lp), 70);
        Token(addrB).approve(address(lp), 53);
        lp.addLiquidity(7, 53);

        (uint256 reserveA, uint256 reserveB, uint32 timestamp) = lp.getReserves();

        // reverse des tokens
        assertEq(reserveA, 7);
        assertEq(reserveB, 53);

        // addLiquidity
        Token(addrB).approve(address(lp), 10);
        lp.addLiquidity(63, 10);
        (reserveA, reserveB, timestamp) = lp.getReserves();

        // reverse des tokens après addliquidity
        assertEq(reserveA, 70);
        assertEq(reserveB, 63);

        vm.stopPrank();
    }

    function test_removeLiquidity() public {
        vm.startPrank(wallet);

        assertEq(Token(addrA).balanceOf(wallet), 500);
        assertEq(Token(addrB).balanceOf(wallet), 300);
        assertEq(Token(addrA).balanceOf(address(lp)), 0);
        assertEq(Token(addrB).balanceOf(address(lp)), 0);

        Token(addrA).approve(address(lp), 100);
        Token(addrB).approve(address(lp), 50);
        uint256 lpNumber = lp.addLiquidity(100, 50);
        assertEq(lpNumber, 150);

        assertEq(Token(addrA).balanceOf(wallet), 400);
        assertEq(Token(addrB).balanceOf(wallet), 250);

        assertEq(Token(addrA).balanceOf(address(lp)), 100);
        assertEq(Token(addrB).balanceOf(address(lp)), 50);

        (uint256 amountA, uint256 amountB) = lp.removeLiquidity(100); 
        console.log(amountA, amountB);  // 66, 33

        assertEq(Token(addrA).balanceOf(address(lp)), 100 - amountA); // 34
        assertEq(Token(addrB).balanceOf(address(lp)), 50 - amountB); // 17

        assertEq(Token(addrA).balanceOf(wallet), 400 + amountA);
        assertEq(Token(addrA).balanceOf(wallet), 466);

        assertEq(Token(addrB).balanceOf(wallet), 250 + amountB);
        assertEq(Token(addrB).balanceOf(wallet), 283);
        
        vm.stopPrank();
    }

        function test_swap() public {
            vm.startPrank(wallet);

            // addLiquidity
            Token(addrA).approve(address(lp), 400);
            Token(addrB).approve(address(lp), 200);
            lp.addLiquidity(400, 200);
            console.log("msg.sender:: ", msg.sender);

            // swap
            Token(addrA).approve(address(lp), 100);
            uint256 quantityB = Token(addrB).balanceOf(wallet);

            uint256 amountB = lp.swap(100, addrA, addrB);
            console.log("amountB: ", amountB);
            assertEq(quantityB + amountB, Token(addrB).balanceOf(wallet));

            Token(addrB).approve(address(lp), 50);
            uint256 quantityA = Token(addrA).balanceOf(wallet);

            uint256 amountA = lp.swap(50, addrB, addrA);
            assertEq(quantityA + amountA, Token(addrA).balanceOf(wallet));

            vm.stopPrank();
        }
}
