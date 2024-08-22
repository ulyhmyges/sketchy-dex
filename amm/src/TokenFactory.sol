// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/AccessControl.sol";
import "./Token.sol";
import {console} from "forge-std/Script.sol";

// The TokenFactory contract is responsible for creating new Token instances
// It uses OpenZeppelin's AccessControl for role-based access control
contract TokenFactory is AccessControl {
    address public STORE_RELAYER = 0xC6A2907273Ab4157EB8594f471cB24F89aF71D3D;
    
    // Array to store the addresses of all deployed tokens
    address[] public deployedTokens;

    // Mapping to store the initial supply of each token by its address
    mapping(address => uint256) public tokenToSupply;

    // Address that holds the FACTORY_ROLE, can deploy new tokens
    address public me = 0x99bdA7fd93A5c41Ea537182b37215567e832A726;
    bytes32 public constant FACTORY_ROLE = keccak256("FACTORY_ROLE");

    // Event emitted when a new token is created
    event TokenCreated(uint256 initialSupply, string name, string symbol);

    constructor() {
        _grantRole(DEFAULT_ADMIN_ROLE, STORE_RELAYER);
        _grantRole(FACTORY_ROLE, me);
    }

    // Function to create a new Token instance
    // Can only be called by addresses with the FACTORY_ROLEs
    function createToken(uint256 initialSupply, string memory name, string memory symbol)
        public
        onlyRole(FACTORY_ROLE)
    {
        address newToken = address(new Token(initialSupply, name, symbol, me));
        tokenToSupply[newToken] = initialSupply;
        deployedTokens.push(newToken);
        emit TokenCreated(initialSupply, name, symbol);
    }

    function getSupply(address _token) public view returns (uint256) {
        return tokenToSupply[_token];
    }

    function getTokens() public view returns (address[] memory) {
        return deployedTokens;
    }

    function getTokenNumber() public view returns (uint256) {
        return deployedTokens.length;
    }
}
