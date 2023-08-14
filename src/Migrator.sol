// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {ERC20} from "solmate/tokens/ERC20.sol";

contract MOCHIMigrator {
    ERC20 public immutable v1;
    ERC20 public immutable v2;

    address immutable burner;

    event Migrated(address user, uint256 amount);

    constructor(ERC20 _v1, ERC20 _v2, address _burner) {
        v1 = _v1;
        v2 = _v2;
        burner = _burner;
    }

    function migrate(uint256 amount) external {
        v1.transferFrom(msg.sender, burner, amount);
        v2.transfer(msg.sender, amount);
        emit Migrated(msg.sender, amount);
    }
}
