/**
 * This file is autogenerated by Scaffold-ETH.
 * You should not edit it manually or your changes might be overwritten.
 */
import { GenericContractsDeclaration } from "~~/utils/scaffold-eth/contract";

const deployedContracts = {
  34443: {
    ModeBalancerVaultFactory: {
      address: "0x14aD61231De340a68a8BBb15cE57B6EeDc7B4193",
      abi: [
        {
          type: "constructor",
          inputs: [
            {
              name: "_management",
              type: "address",
              internalType: "address",
            },
            {
              name: "_performanceFeeRecipient",
              type: "address",
              internalType: "address",
            },
            {
              name: "_keeper",
              type: "address",
              internalType: "address",
            },
          ],
          stateMutability: "nonpayable",
        },
        {
          type: "function",
          name: "deployments",
          inputs: [
            {
              name: "",
              type: "address",
              internalType: "address",
            },
          ],
          outputs: [
            {
              name: "",
              type: "address",
              internalType: "address",
            },
          ],
          stateMutability: "view",
        },
        {
          type: "function",
          name: "isDeployedStrategy",
          inputs: [
            {
              name: "_strategy",
              type: "address",
              internalType: "address",
            },
          ],
          outputs: [
            {
              name: "",
              type: "bool",
              internalType: "bool",
            },
          ],
          stateMutability: "view",
        },
        {
          type: "function",
          name: "keeper",
          inputs: [],
          outputs: [
            {
              name: "",
              type: "address",
              internalType: "address",
            },
          ],
          stateMutability: "view",
        },
        {
          type: "function",
          name: "management",
          inputs: [],
          outputs: [
            {
              name: "",
              type: "address",
              internalType: "address",
            },
          ],
          stateMutability: "view",
        },
        {
          type: "function",
          name: "newModeBalancerVault",
          inputs: [
            {
              name: "_asset",
              type: "address",
              internalType: "address",
            },
            {
              name: "_name",
              type: "string",
              internalType: "string",
            },
          ],
          outputs: [
            {
              name: "",
              type: "address",
              internalType: "address",
            },
          ],
          stateMutability: "nonpayable",
        },
        {
          type: "function",
          name: "performanceFeeRecipient",
          inputs: [],
          outputs: [
            {
              name: "",
              type: "address",
              internalType: "address",
            },
          ],
          stateMutability: "view",
        },
        {
          type: "function",
          name: "setAddresses",
          inputs: [
            {
              name: "_management",
              type: "address",
              internalType: "address",
            },
            {
              name: "_performanceFeeRecipient",
              type: "address",
              internalType: "address",
            },
            {
              name: "_keeper",
              type: "address",
              internalType: "address",
            },
          ],
          outputs: [],
          stateMutability: "nonpayable",
        },
        {
          type: "event",
          name: "NewModeBalancerVault",
          inputs: [
            {
              name: "strategy",
              type: "address",
              indexed: true,
              internalType: "address",
            },
            {
              name: "asset",
              type: "address",
              indexed: true,
              internalType: "address",
            },
          ],
          anonymous: false,
        },
        {
          type: "error",
          name: "AlreadyDeployed",
          inputs: [
            {
              name: "_strategy",
              type: "address",
              internalType: "address",
            },
          ],
        },
      ],
      inheritedFunctions: {},
    },
  },
} as const;

export default deployedContracts satisfies GenericContractsDeclaration;
