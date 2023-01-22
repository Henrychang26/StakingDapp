const networkConfig = {
  default: {
    name: "hardhat",
    keepersUpdateInterval: "30",
  },
  31337: {
    name: "localhost",
    subscriptionId: "588",
    gasLane:
      "0xd89b2bf150e3b9e13446986e571fb9cab24b13cea0a43ea20a6049a85cc807cc", // 30 gwei
    keepersUpdateInterval: "30",
    raffleEntranceFee: ethers.utils.parseEther("0.01"), // 0.01 ETH
    callbackGasLimit: "500000", // 500,000 gas
    factory: "0x1F98431c8aD98523631AE4a59f267346ea31F984",
    WETH9: "0xFCFE742e19790Dd67a627875ef8b45F17DB1DaC6",
  },
  5: {
    name: "goerli",
    subscriptionId: "6926",
    gasLane:
      "0x79d3d8832d904592c0bf9818b621522c988bb8b0c05cdc3b15aea1b6e8db0c15", // 30 gwei
    keepersUpdateInterval: "30",
    raffleEntranceFee: ethers.utils.parseEther("0.01"), // 0.01 ETH
    callbackGasLimit: "500000", // 500,000 gas
    vrfCoordinatorV2: "0x2Ca8E0C643bDe4C2E08ab1fA0da3401AdAD7734D",
    factory: "0x1F98431c8aD98523631AE4a59f267346ea31F984",
    WETH9: "0xFCFE742e19790Dd67a627875ef8b45F17DB1DaC6",
  },
  1: {
    name: "mainnet",
    keepersUpdateInterval: "30",
    factory: "0x1F98431c8aD98523631AE4a59f267346ea31F984",
    WETH9: "0xFCFE742e19790Dd67a627875ef8b45F17DB1DaC6",
  },
}

const developmentChains = ["hardhat", "localhost"]
const VERIFICATION_BLOCK_CONFIRMATIONS = 6

module.exports = {
  developmentChains,
  networkConfig,
  VERIFICATION_BLOCK_CONFIRMATIONS,
}
