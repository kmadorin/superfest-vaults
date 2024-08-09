//SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {ModeBalancerVault} from "./ModeBalancerVault.sol";
import {ITokenizedStrategy} from "@tokenized-strategy/interfaces/ITokenizedStrategy.sol";

contract ModeBalancerVaultFactory {
    /// @notice Revert message for when a strategy has already been deployed.
    error AlreadyDeployed(address _strategy);

    event NewModeBalancerVault(address indexed strategy, address indexed asset);

    address public management;
    address public performanceFeeRecipient;
    address public keeper;

    /// @notice Track the deployments. comet => strategy
    mapping(address => address) public deployments;

    constructor(
        address _management,
        address _performanceFeeRecipient,
        address _keeper
    ) {
        require(_management != address(0), "ZERO ADDRESS");
        management = _management;
        performanceFeeRecipient = _performanceFeeRecipient;
        keeper = _keeper;
    }

    /**
     * @notice Deploy a new Compound Vault
     * @dev This will set the msg.sender to all of the permissioned roles.
     * @param _asset The underlying asset for the vault to use.
     * @param _name The name for the vault to use.
     * @return . The address of the new vault.
     */
    function newModeBalancerVault(
        address _asset,
        string memory _name
    ) external returns (address) {
        if (deployments[_asset] != address(0))
            revert AlreadyDeployed(deployments[_asset]);
        // We need to use the custom interface with the
        // tokenized strategies available setters.
        ITokenizedStrategy newStrategy = ITokenizedStrategy(
            address(
                new ModeBalancerVault(
                    _asset,
                    _name
                )
            )
        );

        newStrategy.setPerformanceFeeRecipient(performanceFeeRecipient);

        newStrategy.setKeeper(keeper);

        newStrategy.setPendingManagement(management);

        emit NewModeBalancerVault(address(newStrategy), _asset);

        deployments[_asset] = address(newStrategy);
        return address(newStrategy);
    }

    function setAddresses(
        address _management,
        address _performanceFeeRecipient,
        address _keeper
    ) external {
        require(msg.sender == management, "!management");
        management = _management;
        performanceFeeRecipient = _performanceFeeRecipient;
        keeper = _keeper;
    }

    function isDeployedStrategy(
        address _strategy
    ) external view returns (bool) {
        address _asset = ITokenizedStrategy(_strategy).asset();
        return deployments[_asset] == _strategy;
    }
}