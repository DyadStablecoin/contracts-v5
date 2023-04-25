// SPDX-License-Identifier: MIT
pragma solidity =0.8.17;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

import {Vault} from "./Vault.sol";
import {Dyad} from "./Dyad.sol";
import {DNft} from "./DNft.sol";
import {IVaultFactory} from "../interfaces/IVaultFactory.sol";

contract VaultFactory is IVaultFactory {
  DNft public immutable dNft;
  Dyad public immutable dyad;

  // collateral => oracle => vault
  mapping(address => mapping(address => address)) public vaults;
  mapping(address => bool)                        public isVault;

  constructor(
    DNft _dNft,
    Dyad _dyad
  ) { 
    dNft = _dNft; 
    dyad = _dyad;
  }

  /// @inheritdoc IVaultFactory
  function deploy(
      address       collat, 
      string memory collatSymbol,
      address       collatOracle
  ) external 
    returns (address) {
      if (collat       == address(0))   revert InvalidCollateral();
      if (collatOracle == address(0))   revert InvalidOracle();
      if (collat       == collatOracle) revert CollateralEqualsOracle();
      if (vaults[collat][collatOracle] != address(0)) revert AlreadyDeployed();

      Vault vault = new Vault(
        address(dNft), 
        collat,
        address(dyad),
        collatOracle
      );

      vaults[collat][collatOracle] = address(vault);
      isVault[address(vault)]      = true;
      emit Deploy(address(vault));
      return address(vault);
  }
}
