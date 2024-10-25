import { HardhatUserConfig, vars } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";

const ALCHEMY_API_KEY = vars.get("ALCHEMY_API_KEY");
const BASESCAN_API_KEY = vars.get("BASESCAN_API_KEY");

const config: HardhatUserConfig = {
  solidity: "0.8.27",
  networks: {
    hardhat: {
      chainId: 1337,
    },
    baseSepolia: {
      url: `https://base-sepolia.g.alchemy.com/v2/${ALCHEMY_API_KEY}`,
      accounts: vars.has("PIVATE_KEY") ? [vars.get("PIVATE_KEY")] : [],
    },
    baseMainnet: {
      url: `https://base-mainnet.g.alchemy.com/v2/${ALCHEMY_API_KEY}`,
      accounts: vars.has("PIVATE_KEY") ? [vars.get("PIVATE_KEY")] : [],
    },
  },
  etherscan: {
    apiKey: {
      baseSepolia: BASESCAN_API_KEY, 
    },
  }
};

export default config;


// 0xF76BF65364B1B0f7668af170139eD66E7F7Bfa0A