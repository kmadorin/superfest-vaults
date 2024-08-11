//SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {BaseStrategy, ERC20} from "@tokenized-strategy/BaseStrategy.sol";
import {IVault} from "./balancer/interfaces/vault/IVault.sol";
import {Errors, _require} from "./balancer/helpers/BalancerErrors.sol";
import {_asIAsset} from "./balancer/helpers/ERC20Helpers.sol";
import {IERC20} from "./balancer/interfaces/solidity-utils/openzeppelin/IERC20.sol";
import {WeightedPoolUserData} from "./balancer/pool-weighted/WeightedPoolUserData.sol";

contract ModeBalancerVault is BaseStrategy {

    address public constant MODE = 0xDfc7C877a950e49D2610114102175A06C2e3167a;
    address public constant USDC = 0xd988097fb8612cc24eeC14542bC03424c656005f;
    address public constant BAL_LP = 0xA4781148e4a8a0903D795464E5c206A7F33851Ba;

    // Balancer vault address
    IVault public balancerVault = IVault(0xBA12222222228d8Ba445958a75a0704d566BF2C8);

    // Balancer 80MODE/20USDC poolId
    bytes32 public constant poolId =
        bytes32(
            0xa4781148e4a8a0903d795464e5c206a7f33851ba000200000000000000000008
        );    

    constructor(
        address _asset,
        string memory _name
    ) BaseStrategy(_asset, _name) {        
        IERC20(MODE).approve(address(balancerVault), type(uint256).max);
    }

    /**
     * @dev Should deploy up to '_amount' of 'asset' in the yield source.
     *
     * This function is called at the end of a {deposit} or {mint}
     * call. Meaning that unless a whitelist is implemented it will
     * be entirely permissionless and thus can be sandwiched or otherwise
     * manipulated.
     *
     * @param _amount The amount of 'asset' that the strategy should attempt
     * to deposit in the yield source.
     */

    function _deployFunds(uint256 _amount) internal override {
        uint256[] memory amountsIn = new uint256[](2);
        amountsIn[0] = 0;
				amountsIn[1] = _amount;
        _joinPool(poolId, amountsIn, 0);
    }

     /**
     * @dev Will attempt to free the '_amount' of 'asset'.
     *
     * The amount of 'asset' that is already loose has already
     * been accounted for.
     *
     * This function is called during {withdraw} and {redeem} calls.
     * Meaning that unless a whitelist is implemented it will be
     * entirely permissionless and thus can be sandwiched or otherwise
     * manipulated.
     *
     * Should not rely on balanceOfAsset() calls other than
     * for diff accounting purposes.
     *
     * Any difference between `_amount` and what is actually freed will be
     * counted as a loss and passed on to the withdrawer. This means
     * care should be taken in times of illiquidity. It may be better to revert
     * if withdraws are simply illiquid so not to realize incorrect losses.
     *
     * @param _amount, The amount of 'asset' to be freed.
     */
    function _freeFunds(uint256 _amount) internal override {
        // Exit the Balancer pool
				exitPool(poolId);
    }

    /**
     * @dev Internal function to harvest all rewards, redeploy any idle
     * funds and return an accurate accounting of all funds currently
     * held by the Strategy.
     *
     * This should do any needed harvesting, rewards selling, accrual,
     * redepositing etc. to get the most accurate view of current assets.
     *
     * NOTE: All applicable assets including loose assets should be
     * accounted for in this function.
     *
     * Care should be taken when relying on oracles or swap values rather
     * than actual amounts as all Strategy profit/loss accounting will
     * be done based on this returned value.
     *
     * This can still be called post a shutdown, a strategist can check
     * `TokenizedStrategy.isShutdown()` to decide if funds should be
     * redeployed or simply realize any profits/losses.
     *
     * @return _totalAssets A trusted and accurate account for the total
     * amount of 'asset' the strategy currently holds including idle funds.
     */
    function _harvestAndReport()
        internal
        override
        returns (uint256 _totalAssets)
    {
        
    }

    /**
     * This function adds liquidity to a Balancer pool
     */
    function _joinPool(
        bytes32 _poolId,
        uint256[] memory amountsIn,
        uint256 minBptAmountOut
    ) public {
        (IERC20[] memory tokens, , ) = balancerVault.getPoolTokens(_poolId);

        // Use BalancerErrors to validate input
        _require(amountsIn.length == tokens.length, Errors.INPUT_LENGTH_MISMATCH);

        // Encode the userData for a multi-token join
        bytes memory userData = abi.encode(WeightedPoolUserData.JoinKind.EXACT_TOKENS_IN_FOR_BPT_OUT, amountsIn, minBptAmountOut);

        // Now the pool is initialized we have to encode a different join into the userData

        IVault.JoinPoolRequest memory request = IVault.JoinPoolRequest({
            assets: _asIAsset(tokens),
            maxAmountsIn: amountsIn,
            userData: userData,
            fromInternalBalance: false
        });

        balancerVault.joinPool(poolId, address(this), address(this), request);
    }

		/**
     * Remove liquidity from Balancer pool
     */
    function exitPool(bytes32 _poolId) public {
        (IERC20[] memory tokens, , ) = balancerVault.getPoolTokens(_poolId);

        // Here we're giving the minimum amounts of each token we'll accept as an output
        // For simplicity we're setting this to all zeros
        uint256[] memory minAmountsOut = new uint256[](tokens.length);

        // As we're exiting the pool we need to make an ExitPoolRequest instead
        IVault.ExitPoolRequest memory request = IVault.ExitPoolRequest({
            assets: _asIAsset(tokens),
            minAmountsOut: minAmountsOut,
            userData: "0x",
            toInternalBalance: false
        });

        balancerVault.exitPool(poolId, address(this), payable(address(this)), request);
    }
}
