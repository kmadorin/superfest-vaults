//SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "../contracts/CompoundVault.sol";
import "../contracts/CompoundVaultFactory.sol";
import "./DeployHelpers.s.sol";
import "../contracts/interfaces/IStrategyInterface.sol";

contract DeployScript is ScaffoldETHDeploy {
  error InvalidPrivateKey(string);

  using SafeERC20 for ERC20;

  // Contract instancees that we will use repeatedly.
  ERC20 public asset;
  IStrategyInterface public strategy;
  CompoundVaultFactory public compoundVaultFactory;

  address public comet = 0xc3d688B66703497DAA19211EEdff47f25384cdc3;
  mapping(string => address) public tokenAddrs;

  // Addresses for different roles we will use repeatedly.
  address public user = address(0x7755B3960E67873C0C4A06bde2A3b3534398cA37);
  address public keeper = address(0x7755B3960E67873C0C4A06bde2A3b3534398cA37);
  address public management = address(0x7755B3960E67873C0C4A06bde2A3b3534398cA37);
  address public performanceFeeRecipient = address(0x7755B3960E67873C0C4A06bde2A3b3534398cA37);

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

    _setTokenAddrs();


    compoundVaultFactory = new CompoundVaultFactory(
        management,
        performanceFeeRecipient,
        keeper
    );

    // Set asset
    asset = ERC20(tokenAddrs["USDC"]);

    // Deploy strategy and set variables

    strategy = IStrategyInterface(
        address(
            compoundVaultFactory.newCompoundVault(
                address(asset),
                "Tokenized Strategy",
                comet,
                0xdbd020CAeF83eFd542f4De03e3cF0C28A4428bd5
            )
        )
    );

    deployments.push(Deployment("tokenized-strategy", address(strategy)));

    console.logString(
      string.concat(
        "CompoundVault deployed at: ", vm.toString(address(strategy))
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

  function _setTokenAddrs() internal {
    tokenAddrs["WBTC"] = 0x2260FAC5E5542a773Aa44fBCfeDf7C193bc2C599;
    tokenAddrs["YFI"] = 0x0bc529c00C6401aEF6D220BE8C6Ea1667F6Ad93e;
    tokenAddrs["WETH"] = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
    tokenAddrs["LINK"] = 0x514910771AF9Ca656af840dff83E8264EcF986CA;
    tokenAddrs["USDT"] = 0xdAC17F958D2ee523a2206206994597C13D831ec7;
    tokenAddrs["DAI"] = 0x6B175474E89094C44Da98b954EedeAC495271d0F;
    tokenAddrs["USDC"] = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;
  }
}
