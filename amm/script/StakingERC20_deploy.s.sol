// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

import {Script, console} from "forge-std/Script.sol";
import {TokenFactory} from "../src/TokenFactory.sol";
import {Token} from "../src/Token.sol";
import {StakingERC20} from "../src/StakingERC20.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract StakingERC20_deployScript is Script {
    TokenFactory public token_factory;
    StakingERC20 public stakingERC20;

    function run() public {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));
        address myAddress = vm.envAddress("WALLET_ADDRESS");

        token_factory = new TokenFactory();
        uint256 nb = token_factory.getTokenNumber();

        console.log("tokens nb: ", nb);
        console.log("sender:", msg.sender);
        token_factory.createToken(55, "Coin", "CN");
        console.log("tokens nb: ", token_factory.getTokenNumber());
        address addr_token = token_factory.getTokens()[0];
        console.log(Token(addr_token).totalSupply());
        console.log(Token(addr_token).symbol());

        //transfert tokens to wallet_address
        IERC20 token = IERC20(addr_token);

        console.log("balanceOf token_factory: ", token.balanceOf(address(token_factory)));
        console.log("my balance token: ", token.balanceOf(myAddress));

        stakingERC20 = new StakingERC20(token);
        token.approve(address(stakingERC20), 30);
        console.log("allowance: ", token.allowance(myAddress, address(stakingERC20)));

        //Set time Stamp first before staking
        stakingERC20.setTimestamp(180);

        //stakeTokens method
        stakingERC20.stakeTokens(token, 30);

        console.log("tokens staked: ", stakingERC20.balances(myAddress));
        vm.stopBroadcast();
    }
}
