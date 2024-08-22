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

    address public myAddress = vm.envAddress("WALLET_ADDRESS");

    function setUp() public {
        vm.startPrank(myAddress);

        tk = new TokenFactory();
        tk.createToken(500, "nameA", "A");
        tk.createToken(300, "nameB", "B");
        addrA = tk.getTokens()[0];
        addrB = tk.getTokens()[1];
        console.log(Token(addrA).balanceOf(address(tk)));
        console.log(Token(addrB).balanceOf(address(tk)));

        lp = new LiquidityPool(addrA, addrB);
        vm.stopPrank();
        lp = new LiquidityPool(addrA, addrB);

    }

    function test_TokenNumber() public {
        vm.startPrank(myAddress);
        assertEq(tk.getTokenNumber(), 2);
        vm.stopPrank();
    }

    function test_addLiquidity() public {
        //vm.startPrank(address(tk));
        vm.startPrank(myAddress);
        console.log(Token(addrA).balanceOf(myAddress));
        console.log(Token(addrB).balanceOf(myAddress));

        Token(addrA).approve(address(lp), 7);
        Token(addrB).approve(address(lp), 50);
        uint256 lpNumber = lp.addLiquidity(7, 50);
        assertEq(lpNumber, 57);
        vm.stopPrank();
    }

    function test_getReserves() public {
        vm.startPrank(myAddress);

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

    // function test_removeLiquidity() public {
    //     vm.startPrank(address(tk));

    //     assertEq(Token(addrA).balanceOf(address(tk)), 500);
    //     assertEq(Token(addrB).balanceOf(address(tk)), 300);
    //     assertEq(Token(addrA).balanceOf(address(lp)), 0);
    //     assertEq(Token(addrB).balanceOf(address(lp)), 0);

    //     Token(addrA).approve(address(lp), 70);
    //     Token(addrB).approve(address(lp), 50);
    //     uint256 lpNumber = lp.addLiquidity(70, 50);
    //     assertEq(lpNumber, 120);

    //     assertEq(Token(addrA).balanceOf(address(tk)), 430);
    //     assertEq(Token(addrB).balanceOf(address(tk)), 250);

    //     assertEq(Token(addrA).balanceOf(address(lp)), 70);
    //     assertEq(Token(addrB).balanceOf(address(lp)), 50);

    //     (uint256 amountA, uint256 amountB) = lp.removeLiquidity(100);
    //     console.log(amountA, amountB);

    //     assertEq(Token(addrA).balanceOf(address(lp)), 70 - amountA);
    //     assertEq(Token(addrB).balanceOf(address(lp)), 50 - amountB);

    //     assertEq(Token(addrA).balanceOf(address(tk)), 430 + amountA);
    //     assertEq(Token(addrB).balanceOf(address(tk)), 250 + amountB);
    //     vm.stopPrank();
    // }

    //     function test_swap() public {
    //         vm.startPrank(address(tk));

    //         // addLiquidity
    //         Token(addrA).approve(address(lp), 70);
    //         Token(addrB).approve(address(lp), 200);
    //         lp.addLiquidity(70, 200);
    //         console.log("msg.sender:: ", msg.sender);

    //         Token(addrA).approve(address(lp), 10);
    //         uint256 quantityB = Token(addrB).balanceOf(address(tk));

    //         uint256 amountB = lp.swap(10, addrA, addrB);
    //         console.log("amountB: ", amountB);
    //         assertEq(quantityB + amountB, Token(addrB).balanceOf(address(tk)));

    //         Token(addrB).approve(address(lp), 10);
    //         uint256 quantityA = Token(addrA).balanceOf(address(tk));

    //         uint256 amountA = lp.swap(2, addrB, addrA);
    //         assertEq(quantityA + amountA, Token(addrA).balanceOf(address(tk)));

    //         vm.stopPrank();
    //     }
}
