// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "../../libraries/LibAppStorage.sol";
import "@chainlink/contracts/src/v0.8/VRFConsumerBase.sol";
import "@chainlink/contracts/src/v0.8/ConfirmedOwner.sol";

contract DiceRollsFacet is VRFConsumerBase, ConfirmedOwner(msg.sender) {
  AppStorage storage s;


  bytes32 private s_keyHash;
  uint256 private s_fee;
  uint256 public randomResult;

  constructor(address vrfCoordinator, address link, bytes32 keyHash, uint256 fee)
    VRFConsumerBase(vrfCoordinator, link)
  {
    s_keyHash = keyHash;
    s_fee = fee;
  }

  // Request randomness
  function getRandomNumber() public returns (bytes32 requestId) {
    require(LINK.balanceOf(address(this)) >= s_fee, "Not enough LINK - fill contract with faucet");

    return requestRandomness(s_keyHash, s_fee);
  }

  // Callback function used by VRF Coordinator
  function fulfillRandomness(bytes32 requestId, uint256 randomness) internal override {
    randomResult = randomness;
  }

  // Roll Dice function
  function rollDice(address roller) public onlyOwner returns (bytes32 requestId) {
      // checking LINK balance
      require(LINK.balanceOf(address(this)) >= s_fee, "Not enough LINK to pay fee");

      // checking if roller has already rolled die
      require(s_results[roller] == 0, "Already rolled");

      // requesting randomness
      requestId = requestRandomness(s_keyHash, s_fee);

      // storing requestId and roller address
      s_rollers[requestId] = roller;

      // emitting event to signal rolling of die
      s_results[roller] = ROLL_IN_PROGRESS;
      emit DiceRolled(requestId, roller);
  }
}