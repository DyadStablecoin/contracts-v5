// SPDX-License-Identifier: MIT
pragma solidity =0.8.17;

import {DNft} from "../core/DNft.sol";
import {IVaultsManager} from "../interfaces/IVaultsManager.sol";

contract VaultsManager is IVaultsManager {
  DNft public immutable dNft;

  mapping(address => bool)                  public vaults;
  mapping(address => uint)                  public vaultVotes;
  mapping(uint => mapping(address => bool)) public hasVoted;

  uint public immutable MIN_VOTES; // will change

  modifier isNftOwner(uint id) {
    if (dNft.ownerOf(id) != msg.sender) revert NotOwner(); _;
  }

  constructor(DNft _dNft, uint _minVotes) {
    dNft      = _dNft;
    MIN_VOTES = _minVotes;
  }

  /// @inheritdoc IVaultsManager
  function voteFor(
      uint id,
      address vault
    ) 
    external 
      isNftOwner(id) 
    {
      if (hasVoted[id][msg.sender]) revert AlreadyVotedFor(); 
      vaultVotes[vault] += 1;
      emit Voted(id, vault, true);
  }

  /// @inheritdoc IVaultsManager
  function voteAgainst(
      uint id,
      address vault
    ) 
    external 
      isNftOwner(id) 
    {
      if (!hasVoted[id][msg.sender]) revert AlreadyVotedAgainst(); 
      vaultVotes[vault] -= 1;
      emit Voted(id, vault, false);
  }

  function addVault(address _vault) external {
    if (vaultVotes[_vault] < MIN_VOTES) revert TooManyAgainstVotes();
    vaults[_vault] = true;
  }

  function removeVault(address _vault) external {
    if (vaultVotes[_vault] > MIN_VOTES) revert TooManyForVotes();
    vaults[_vault] = false;
  }
}
