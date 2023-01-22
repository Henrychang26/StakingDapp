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

contract Staking {
  IERC20 public s_stakingToken;

  uint256 public s_totalSupply;

  //Someones address to how much they stake
  mapping(address => uint256) private s_balances;

  constructor(address stakingToken) {
    s_stakingToken = IERC20(stakingToken);
  }

  event TokenStaked(address indexed client, uint256 indexed amount);

  modifier onlyOwner() {
    // require(msg.sender == s_balances[]);
  }

  //Do we allow any tokens? (Need chainlink to convert prices)
  //Or just a specific token?
  function stake(uint256 amount) external {
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

  function withdraw(uint256 amount) external {
    s_balances[msg.sender] = s_balances[msg.sender] - amount;
    s_totalSupply = s_totalSupply - amount;

    bool success = s_stakingToken.transfer(msg.sender, amount);
    if (!success) {
      revert Staking__TransferFailed();
    }
  }
}
