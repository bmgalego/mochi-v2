// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

/**
 * __  __  _____  ___  _   _  ____
 * (  \/  )(  _  )/ __)( )_( )(_  _)
 *  )    (  )(_)(( (__  ) _ (  _)(_
 * (_/\/\_)(_____)\___)(_) (_)(____)
 *
 *  https://t.me/mochientry
 */

import {ERC20} from "solmate/tokens/ERC20.sol";

contract MOCHI is ERC20("Mochi", "MOCHI", 8) {
    constructor() {
        _mint(msg.sender, 100_000_000e8);
    }
}
