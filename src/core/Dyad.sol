// SPDX-License-Identifier: MIT
pragma solidity =0.8.17;

import {Owned} from "@solmate/src/auth/Owned.sol";
import {ERC20} from "@solmate/src/tokens/ERC20.sol";
import {VaultsManager} from "../composing/VaultsManager.sol";

contract Dyad is ERC20 {
  VaultsManager public immutable vaultsManager;

  error Unauthorized();

  constructor(VaultsManager _vaultsManager)
    ERC20("DYAD Stablecoin", "DYAD", 18) {
      vaultsManager = VaultsManager(_vaultsManager);
  }

  function mint(
      address to,
      uint    amount
  ) external {
      if (vaultsManager.vaultVotes(msg.sender) < 800) revert Unauthorized();
      _mint(to, amount);
  }

  function burn(
      address from,
      uint    amount
  ) external {
      if (vaultsManager.vaultVotes(msg.sender) < 800) revert Unauthorized();
      _burn(from, amount);
  }
}
