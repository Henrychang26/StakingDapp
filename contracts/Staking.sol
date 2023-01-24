// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

//Stake: Lock tokens into our smart contract
//Withdraw: unlock tokens and pull out of the contract
//ClaimReward: users get their reward tokens

//What's a good reward mechanism
//What's some good rewards

error Staking__NotEnoughEth();
error Staking__TransferFailed();
error Staking__NeedsMoreThanZero();

contract Staking {
  IERC20 public s_stakingToken;
  IERC20 public s_rewardsToken;

  uint256 public constant REWARD_RATE = 100;
  uint256 public s_totalSupply;
  uint256 public s_rewardPerTokenStored;
  uint256 public s_lastUpdateTime;

  //Someones address to how much they stake
  mapping(address => uint256) private s_balances;
  //Mapping of how much each address has been paid
  mapping(address => uint256) private s_userRewardPerTokenPaid;
  //mapping of how much rewards each address has
  mapping(address => uint256) private s_rewards;

  constructor(address stakingToken, address rewardsToken) {
    s_stakingToken = IERC20(stakingToken);
    s_rewardsToken = IERC20(rewardsToken);
  }

  event TokenStaked(address indexed client, uint256 indexed amount);

  modifier updateReward(address account) {
    //how much reward per token?
    //last timestamp
    //time difference, user earned X tokens
    s_rewardPerTokenStored = rewardPerToken();
    s_lastUpdateTime = block.timestamp;
    s_rewards[account] = earned(account);
    s_userRewardPerTokenPaid[account] = s_rewardPerTokenStored;
    _;
  }

  modifier moreThanZero(uint256 amount) {
    if (amount == 0) {
      revert Staking__NeedsMoreThanZero();
    }
    _;
  }

  function earned(address account) public view returns (uint256) {
    uint256 currentBalance = s_balances[account];
    //How much they have been paid already
    uint256 amountPaid = s_userRewardPerTokenPaid[account];
    uint256 currentRewardPerToken = rewardPerToken();
    uint256 pastReward = s_rewards[account];

    uint256 _earned = ((currentBalance * (currentRewardPerToken - amountPaid)) /
      1e18) + pastReward;

    return _earned;
  }

  //Based on how long its beenn during this most recent snapshot
  function rewardPerToken() public view returns (uint256) {
    if (s_totalSupply == 0) {
      return s_rewardPerTokenStored;
    }
    return
      s_rewardPerTokenStored +
      (((block.timestamp - s_lastUpdateTime) * REWARD_RATE * 1e18) /
        s_totalSupply);
  }

  //Do we allow any tokens? (Need chainlink to convert prices)
  //Or just a specific token?
  function stake(
    uint256 amount
  ) external updateReward(msg.sender) moreThanZero(amount) {
    //Keep track of how much this user has staked
    //Keep track of how much token we have total
    //Transfer the tokens to this contract

    if (amount == 0) {
      revert Staking__NotEnoughEth();
    }

    s_balances[msg.sender] = s_balances[msg.sender] + amount;
    s_totalSupply = s_totalSupply + amount;

    bool success = s_stakingToken.transferFrom(
      msg.sender,
      address(this),
      amount
    );
    if (!success) {
      revert Staking__TransferFailed();
    }

    emit TokenStaked(msg.sender, amount);
  }

  function withdraw(
    uint256 amount
  ) external updateReward(msg.sender) moreThanZero(amount) {
    s_balances[msg.sender] = s_balances[msg.sender] - amount;
    s_totalSupply = s_totalSupply - amount;

    bool success = s_stakingToken.transfer(msg.sender, amount);
    if (!success) {
      revert Staking__TransferFailed();
    }
  }

  function claimReward() external updateReward(msg.sender) {
    //How much reward do they get?
    //The contract is going to emit X tokens per second
    //And disperse them to all token stakers
    //100 tokens / second
    //50 staked tokens, 20 staked tokens, 30 staked tokens
    //Reward: 50 reward tokens, 20 reward tokens, 30 reward tokens
    //Staked: 100, 50, 20, 30 (total = 200)
    //Rewards: 50, 25, 10, 15
    uint256 reward = s_rewards[msg.sender];
    bool success = s_rewardsToken.transfer(msg.sender, reward);
    if (!success) {
      revert Staking__TransferFailed();
    }
  }
}
