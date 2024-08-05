import { defineChain } from "viem";

// import path from "node:path";

const rpcUrl = process.env.NEXT_PUBLIC_VIRTUAL_MAINNET_RPC_URL!;
const tenderlyId = rpcUrl?.split("/").pop();

export const vMainnet = defineChain({
  id: 173571,
  name: "Virtual Ethereum Mainnet",
  nativeCurrency: { name: "vEther", symbol: "vETH", decimals: 18 },
  rpcUrls: {
    default: { http: [rpcUrl] },
  },
  blockExplorers: {
    default: {
      name: "Tenderly Explorer",
      url: `https://dashboard.tenderly.co/explorer/vnet/${tenderlyId}`,
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
