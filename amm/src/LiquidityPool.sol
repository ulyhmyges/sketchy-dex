// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/math/Math.sol";

contract LiquidityPool {
    using Math for uint256;

    IERC20 public tokenA;
    IERC20 public tokenB;
    uint256 public reserveA;
    uint256 public reserveB;
    mapping(address => uint256) public liquidity;
    uint256 public rateTokenBFromTokenA = 2;

    constructor(address _tokenA, address _tokenB) {
        require(_tokenA != address(0));
        require(_tokenB != address(0));
        require(_tokenA != _tokenB);
        tokenA = IERC20(_tokenA);
        tokenB = IERC20(_tokenB);
    }

    event AddLiquidity(address indexed provider, uint256 amountA, uint256 amountB, uint256 liquidity);
    event RemoveLiquidity(address indexed provider, uint256 amountA, uint256 amountB, uint256 liquidity);
    event Swap(address trader, uint256 amountIn, uint256 amountOut, address tokenIn, address tokenOut);

    // : Allows users to deposit an equal value of two tokens into the pool.
    // This increases the pool's liquidity,
    // and in return, users receive liquidity provider (LP) tokens representing their share in the pool.
    function addLiquidity(uint256 amountA, uint256 amountB) external returns (uint256) {
        require(amountA > 0 && amountB > 0, "Invalid amounts");

        tokenA.transferFrom(msg.sender, address(this), amountA);

        tokenB.transferFrom(msg.sender, address(this), amountB);

        uint256 liquidityMinted = amountA + amountB; // Simplified liquidity calculation
        liquidity[msg.sender] += liquidityMinted;

        reserveA += amountA;
        reserveB += amountB;

        emit AddLiquidity(msg.sender, amountA, amountB, liquidityMinted);
        return liquidityMinted;
    }

    /**
     *
     * @param liquidityAmount LP tokens
     * @return amountA of tokenA
     * @return amountB of tokenB
     *
     * Allows users to withdraw their tokens from the pool by redeeming their LP tokens.
     * The function calculates and transfers the appropriate amount of each token back to the user.
     */
    function removeLiquidity(uint256 liquidityAmount) external returns (uint256 amountA, uint256 amountB) {
        require(liquidityAmount > 0, "Invalid liquidity amount");
        require(liquidity[msg.sender] >= liquidityAmount, "Not enough liquidity");

        uint256 totalLiquidity = reserveA + reserveB; // Simplified total liquidity calculation
        amountA = (liquidityAmount * reserveA) / totalLiquidity;
        amountB = (liquidityAmount * reserveB) / totalLiquidity;

        liquidity[msg.sender] -= liquidityAmount;

        reserveA -= amountA;
        reserveB -= amountB;

        tokenA.transfer(msg.sender, amountA);
        tokenB.transfer(msg.sender, amountB);

        emit RemoveLiquidity(msg.sender, amountA, amountB, liquidityAmount);
    }

    /**
     *
     * @param amountIn in
     * @param tokenIn tokenA or tokenB
     * @param tokenOut tokenA or tokenB
     *
     * Purpose: Enables users to trade one token for another within the pool.
     */
    function swap(uint256 amountIn, address tokenIn, address tokenOut) public returns (uint256 amountOut) {
        require(amountIn > 0, "Invalid amount in");
        require(amountIn >= rateTokenBFromTokenA, "Not enough amount in to swap.");
        require(
            (tokenIn == address(tokenA) && tokenOut == address(tokenB))
                || (tokenIn == address(tokenB) && tokenOut == address(tokenA)),
            "Invalid tokens"
        );

        IERC20 inputToken = IERC20(tokenIn);
        IERC20 outputToken = IERC20(tokenOut);

        inputToken.transferFrom(msg.sender, address(this), amountIn);

        if (tokenIn == address(tokenA)) {
            //amountOut = (amountIn * reserveB) / reserveA; // Simplified constant product formula
            amountOut = amountIn * rateTokenBFromTokenA;
            reserveA += amountIn;
            reserveB -= amountOut;
        } else {
            //amountOut = (amountIn * reserveA) / reserveB; // Simplified constant product formula

            // use Library Math
            //amountOut = amountIn * (1 / rateTokenBFromTokenA);

            bool boolean = false;
            (boolean, amountOut) = Math.tryDiv(amountIn, rateTokenBFromTokenA);

            reserveB += amountIn;
            reserveA -= amountOut;
        }

        outputToken.transfer(msg.sender, amountOut);

        emit Swap(msg.sender, amountIn, amountOut, tokenIn, tokenOut);
    }

    /**
     *
     * @return _reserveA of tokenA
     * @return _reserveB of tokenB
     * @return blockTimestampLast time
     *
     * Returns the current reserves of the two tokens in the pool.
     * This information is essential for determining swap rates and the value of LP tokens.
     */
    function getReserves() external view returns (uint256 _reserveA, uint256 _reserveB, uint32 blockTimestampLast) {
        _reserveA = reserveA;
        _reserveB = reserveB;
        blockTimestampLast = uint32(block.timestamp);
    }

    /**
     * @param to ??
     *
     * Purpose: Mint LP tokens.
     * Internal function called when adding liquidity.
     * Mints new LP tokens proportionate to the amount of liquidity added.
     */
    //function mint(address to) internal returns (uint256 liquidity);

    /**
     * @param to ???
     * @return amountA for tokenA
     * @return amountB for tokenB
     *
     * Purpose: Burn LP tokens.
     * Internal function called when removing liquidity.
     * Burns the LP tokens being redeemed.
     */
    //function burn(address to) internal returns (uint256 amountA, uint256 amountB);

    /**
     * Purpose: Updates the price of the tokens in the pool based on recent trades.
     * This function helps in maintaining accurate pricing for swaps.
     *
     * @param amountA for  tokenA
     * @param amountB for tokenB
     */
    //function updatePrice(uint256 amountA, uint256 amountB) internal;

    /**
     *
     * Purpose: Collects transaction fees accumulated in the pool,
     * which can be distributed to liquidity providers or used for other purposes like protocol maintenance.
     */
    //function collectFees() internal;
}
