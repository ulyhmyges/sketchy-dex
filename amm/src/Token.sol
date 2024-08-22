// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

//"@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {console} from "forge-std/Script.sol";

contract Token is ERC20 {

    // Constructor takes the following parameters:
    // - initialSupply:     The initial amount of tokens to mint (create)
    // - name:              The name of the token
    // - symbol:            The symbol of the token
    // - account:           The address that will receive the initial supply of tokens
    constructor(uint256 initialSupply, string memory name, string memory symbol, address account) ERC20(name, symbol) {
        _mint(account, initialSupply);
    }
}
