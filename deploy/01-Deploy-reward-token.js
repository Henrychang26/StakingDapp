const { network } = require("hardhat")
const {
  VERIFICATION_BLOCK_CONFIRMATIONS,
  developmentChains,
} = require("../helper-hardhat.config")
const { verify } = require("../utils/verify")

module.exports = async ({ getNamedAccounts, deployments }) => {
  const { deploy, log } = deployments
  const { deployer } = await getNamedAccounts()
  const waitBlockConfirmations = developmentChains.includes(network.name)
    ? 1
    : VERIFICATION_BLOCK_CONFIRMATIONS

  const args = []

  log("-----------------------------")
  const rewardToken = await deploy("RewardToken", {
    from: deployer,
    args: args,
    log: true,
    waitConfirmations: waitBlockConfirmations,
  })

  if (!developmentChains.includes(network.name) && ETHERSCAP_API_KEY) {
    log("Verifying.....")
    await verify(rewardToken.address, args)
  }
  log("-----------------------------")
}

module.exports.tags = ["all", "rewardtoken"]
