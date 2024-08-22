// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

import {Script, console} from "forge-std/Script.sol";
import {Token} from "../src/Token.sol";

contract TokenScript is Script {
    Token public token;
    address public wallet;

    function run() public {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));

        wallet = vm.envAddress("WALLET_ADDRESS");
        token = new Token(50, "MyToken", "MTK", wallet);

        console.log("balance: of sender", token.balanceOf(msg.sender));
        console.log("totalSupply: ", token.totalSupply());
        console.log("Token Symbol: ", token.symbol());

        vm.stopBroadcast();
    }
}
