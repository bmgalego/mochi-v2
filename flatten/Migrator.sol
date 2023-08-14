// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

interface IERC20 {
    function transfer(address to, uint256 amount) external returns (bool);
    function transferFrom(address from, address to, uint256 amount) external returns (bool);
}

contract MOCHIMigrator {
    IERC20 public immutable v1;
    IERC20 public immutable v2;

    address immutable burner;

    event Migrated(address user, uint256 amount);

    constructor(IERC20 _v1, IERC20 _v2, address _burner) {
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

