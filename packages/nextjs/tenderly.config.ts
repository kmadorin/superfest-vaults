import { defineChain } from "viem";

// import path from "node:path";

const virtualMainnetRpcUrl = process.env.NEXT_PUBLIC_VIRTUAL_MAINNET_RPC_URL!;
const modeVirtualMainnetRpcUrl = process.env.NEXT_PUBLIC_VIRTUAL_MAINNET_RPC_URL!;
const virtualMainnetId = virtualMainnetRpcUrl?.split("/").pop();
const modeVirtualMainnetId = modeVirtualMainnetRpcUrl?.split("/").pop();

export const vMainnet = defineChain({
  id: 173571,
  name: "Virtual Ethereum Mainnet",
  nativeCurrency: { name: "vEther", symbol: "vETH", decimals: 18 },
  rpcUrls: {
    default: { http: [virtualMainnetRpcUrl] },
  },
  blockExplorers: {
    default: {
      name: "Tenderly Explorer",
      url: `https://dashboard.tenderly.co/explorer/vnet/${virtualMainnetId}`,
    },
  },
});

export const vModeMainnet = defineChain({
  id: 34443,
  name: "Virtual Mode Mainnet",
  nativeCurrency: { name: "vMEther", symbol: "vMETH", decimals: 18 },
  rpcUrls: {
    default: { http: [modeVirtualMainnetRpcUrl] },
  },
  blockExplorers: {
    default: {
      name: "Tenderly Explorer",
      url: `https://dashboard.tenderly.co/explorer/vnet/${modeVirtualMainnetId}`,
    },
  },
});

// export type TSetBalanceRpc = {
//   method: "tenderly_setBalance",
//   Parameters: [addresses: Hex[], value: Hex],
//   ReturnType: Hex
// }

// export type TSetErc20BalanceRpc = {
//   method: "tenderly_setErc20Balance",
//   Parameters: [erc20: Hex, to: Hex, value: Hex],
//   ReturnType: Hex
// }
