//SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {BaseStrategy, ERC20} from "@tokenized-strategy/BaseStrategy.sol";

contract ModeBalancerVault is BaseStrategy {
    using safeERC20 for ERC20;
    address public constant MODE = 0xDfc7C877a950e49D2610114102175A06C2e3167a;
    address public constant USDC = 0xd988097fb8612cc24eeC14542bC03424c656005f;

    IVault public vault = IVault(0xBA12222222228d8Ba445958a75a0704d566BF2C8);

    constructor(
        address _asset,
        string memory _name
    ) BaseStrategy(_asset, _name) {

    }
}
