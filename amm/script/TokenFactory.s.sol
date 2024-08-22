// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

import {Script, console} from "forge-std/Script.sol";
import {TokenFactory} from "../src/TokenFactory.sol";
import {Token} from "../src/Token.sol";
import {StakingERC20} from "../src/StakingERC20.sol";

contract TokenFactoryScript is Script {
    TokenFactory public token_factory;
    StakingERC20 public staking;

    function run() public {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));
        //token_factory = new TokenFactory();

        // uint256 nb = token_factory.getTokenNumber();
        // console.log("nb: ", nb);
        // console.log("sender:", msg.sender);
        // token_factory.createToken(55, "Coin", "CN");
        // console.log(token_factory.getTokenNumber());
        // address add = token_factory.getTokens()[0];
        // console.log(Token(add).totalSupply());
        // console.log(Token(add).symbol());

        //blockchain holesky
        token_factory = TokenFactory(0xD5A8F352C4f5E594163019C15dbcBbd6bd2cB193);
        console.log("nb: ", token_factory.getTokenNumber());
        console.log(Token(token_factory.getTokens()[0]).symbol());
        console.log("supply Token1: ", token_factory.getSupply(token_factory.getTokens()[0]));

        staking = StakingERC20(0xa4Cfc0A8bcB5ea844321b96aBe06DbD0e08D0630);
        console.log("timePeriod: ", staking.timePeriod());
        console.log("timestampset: ", staking.timestampSet());
        console.log("balance owner: ", staking.balances(staking.owner()));
        vm.stopBroadcast();
    }
}
