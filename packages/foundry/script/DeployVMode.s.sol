//SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "../contracts/ModeBalancerVault.sol";
import "../contracts/ModeBalancerVaultFactory.sol";
import "./DeployHelpers.s.sol";
import "@tokenized-strategy/interfaces/ITokenizedStrategy.sol";

contract DeployScript is ScaffoldETHDeploy {
  error InvalidPrivateKey(string);

  // Contract instancees that we will use repeatedly.
  ITokenizedStrategy public strategy;
  ModeBalancerVaultFactory public modeBalancerVaultFactory;


  // Addresses for different roles we will use repeatedly.
  address public user = address(0x7755B3960E67873C0C4A06bde2A3b3534398cA37);
  address public keeper = address(0x7755B3960E67873C0C4A06bde2A3b3534398cA37);
  address public management = address(0x7755B3960E67873C0C4A06bde2A3b3534398cA37);
  address public performanceFeeRecipient = address(0x7755B3960E67873C0C4A06bde2A3b3534398cA37);
  address public constant MODE = 0xDfc7C877a950e49D2610114102175A06C2e3167a;


  // Address of the real deployed Factory
  address public factory;

  function run() external {
    uint256 deployerPrivateKey = setupLocalhostEnv();

    if (deployerPrivateKey == 0) {
      revert InvalidPrivateKey(
        "You don't have a deployer account. Make sure you have set DEPLOYER_PRIVATE_KEY in .env or use `yarn generate` to generate a new random account"
      );
    }
    vm.startBroadcast(deployerPrivateKey);

    modeBalancerVaultFactory = new ModeBalancerVaultFactory(
        management,
        performanceFeeRecipient,
        keeper
    );


    // Deploy strategy and set variables

    strategy = ITokenizedStrategy(
        address(
            modeBalancerVaultFactory.newModeBalancerVault(
                address(MODE),
                "Mode Balancer Tokenized Strategy"
            )
        )
    );

    deployments.push(Deployment("mode-balancer-tokenized-strategy", address(strategy)));

    console.logString(
      string.concat(
        "ModeBalancerVault deployed at: ", vm.toString(address(strategy))
      )
    );

    vm.stopBroadcast();

    /**
     * This function generates the file containing the contracts Abi definitions.
     * These definitions are used to derive the types needed in the custom scaffold-eth hooks, for example.
     * This function should be called last.
     */
    exportDeployments();

  }

  function test() public { }
}
