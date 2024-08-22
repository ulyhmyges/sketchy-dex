// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

import {Script, console} from "forge-std/Script.sol";
import {TokenFactory} from "../src/TokenFactory.sol";
import {Token} from "../src/Token.sol";
import {StakingERC20} from "../src/StakingERC20.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract StakingERC20Script is Script {
    TokenFactory public token_factory;
    StakingERC20 public stakingERC20;
    Token public token;

    function run() public {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));
        address myAddress = vm.envAddress("WALLET_ADDRESS");
        token = new Token(500, "BB", "BB", myAddress);
        stakingERC20 = new StakingERC20(token);

        //stakeTokens method
        //stakingERC20.unstakeTokens(token, 30);

        console.log("tokens staked: ", stakingERC20.balances(myAddress));
        vm.stopBroadcast();
    }
}
