const { network } = require("hardhat")
const {
  VERIFICATION_BLOCK_CONFIRMATIONS,
  developmentChains,
} = require("../helper-hardhat.config")
const { verify } = require("../utils/verify")

module.exports = async ({ getNamedAccounts, deployments }) => {
  const { deploy, log } = deployments
  const { deployer } = await getNamedAccounts()
  const rewardToken = await deployments.get("RewardToken")
  const waitBlockConfirmations = developmentChains.includes(network.name)
    ? 1
    : VERIFICATION_BLOCK_CONFIRMATIONS

  log("-----------------------------")

  const args = [rewardToken.address, rewardToken.address]

  log("Deploying...")

  const staking = await deploy("Staking", {
    from: deployer,
    args: args,
    log: true,
    waitConfirmations: waitBlockConfirmations,
  })

  if (!developmentChains.includes(network.name) && ETHERSCAN_API_KEY) {
    log("Verifying...")
    await verify(staking.address, args)
  }
}
module.exports.tags = ["all", "staking"]
