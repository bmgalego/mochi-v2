// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {ERC20} from "solmate/tokens/ERC20.sol";

contract MOCHI is ERC20("MOCHI", "MOCHI", 8) {
    constructor() {
        _mint(msg.sender, 100_000_00e8);
    }
}
