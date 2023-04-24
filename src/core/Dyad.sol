// SPDX-License-Identifier: MIT
pragma solidity =0.8.17;

import {Owned} from "@solmate/src/auth/Owned.sol";
import {ERC20} from "@solmate/src/tokens/ERC20.sol";
import {VaultsManager} from "../composing/VaultsManager.sol";

contract Dyad is ERC20, Owned {
  VaultsManager public immutable vaultsManager;

  error Unauthorized();

  constructor(
    string memory name, 
    string memory symbol, 
    address owner, 
    address _vaultsManager
  ) ERC20(name, symbol, 18) 
    Owned(owner) {
      vaultsManager = VaultsManager(_vaultsManager);
  }

  function mint(
      address to,
      uint    amount,
      address vault
  ) external {
      if (vaultsManager.vaultVotes(vault) < 40) revert Unauthorized();
      _mint(to, amount);
  }

  function burn(
      address from,
      uint    amount, 
      address vault
  ) external {
      if (vaultsManager.vaultVotes(vault) < 40) revert Unauthorized();
      _burn(from, amount);
  }
}
