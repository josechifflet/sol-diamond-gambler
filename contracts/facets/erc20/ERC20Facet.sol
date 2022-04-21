// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {LibDiamond} from "../../libraries/LibDiamond.sol";
import "@solidstate/contracts/token/ERC20/ERC20.sol";

contract ERC20Facet is ERC20 {
    function _beforeTokenTransfer(
        address,
        address,
        uint256
    ) internal view override {
        LibDiamond.enforceIsContractOwner();
    }
}
