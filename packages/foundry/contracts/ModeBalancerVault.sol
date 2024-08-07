//SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {BaseStrategy, ERC20} from "@tokenized-strategy/BaseStrategy.sol";
import {IVault} from "./balancer/IVault.sol";
import {Errors} from "./balancer/BalancerErrors.sol";
import {_asIAsset} from "./balancer/ERC20Helpers.sol";

contract ModeBalancerVault is BaseStrategy {
    using safeERC20 for ERC20;

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
        IERC20(MODE).safeApprove(address(balancerVault), type(uint256).max);
        IERC20(USDC).safeApprove(address(balancerVault), type(uint256).max);
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
        _joinPool(_amount, 0);
    }

    /**
     * This function adds liquidity to a Balancer pool
     */
    function _joinPool(
        uint256[] memory amountsIn,
        uint256 memory minBptAmountOut,
    ) public onlyMultisig {
        (IERC20[] memory tokens, , ) = balancerVault.getPoolTokens(poolId);

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
}
