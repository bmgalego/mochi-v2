// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

interface IERC721 {
    function transferFrom(address from, address to, uint256 tokenId) external;
}

interface INonfungiblePositionManager is IERC721 {
    struct CollectParams {
        uint256 tokenId;
        address recipient;
        uint128 amount0Max;
        uint128 amount1Max;
    }

    function collect(CollectParams calldata params) external payable returns (uint256 amount0, uint256 amount1);
}

contract MOCHILPLocker {
    INonfungiblePositionManager constant positionManager =
        INonfungiblePositionManager(0x80C7DD17B01855a6D2347444a0FCC36136a314de);

    address public lpFeeCollector;

    mapping(uint256 => uint256) public lockUpDeadline;
    mapping(uint256 => bool) public nftLocked;
    mapping(uint256 => bool) public withdrawTriggered;

    modifier onlyLPFeeCollector() {
        require(msg.sender == lpFeeCollector);
        _;
    }

    constructor() {
        lpFeeCollector = msg.sender;
    }

    function lockNFT(uint256 _tokenId) external onlyLPFeeCollector {
        require(!nftLocked[_tokenId], "NFT is already locked");
        positionManager.transferFrom(msg.sender, address(this), _tokenId);
        nftLocked[_tokenId] = true;
    }

    function triggerNFTWithdrawal(uint256 _tokenId) external onlyLPFeeCollector {
        require(nftLocked[_tokenId], "NFT is not locked");
        require(lockUpDeadline[_tokenId] == 0, "Withdrawal has been already triggered");
        lockUpDeadline[_tokenId] = block.timestamp + (7 days);
        withdrawTriggered[_tokenId] = true;
    }

    function cancelNFTWithdrawal(uint256 _tokenId) external onlyLPFeeCollector {
        require(nftLocked[_tokenId], "NFT is not locked");
        require(lockUpDeadline[_tokenId] != 0, "Withdrawal has not been triggered");
        lockUpDeadline[_tokenId] = 0;
        withdrawTriggered[_tokenId] = false;
    }

    function withdrawNFT(uint256 _tokenId) external onlyLPFeeCollector {
        require(nftLocked[_tokenId], "NFT is not locked");
        require(lockUpDeadline[_tokenId] != 0, "Withdrawal  has not been triggered");
        require(block.timestamp >= lockUpDeadline[_tokenId], "Lock-up period has not ended yet");
        positionManager.transferFrom(address(this), msg.sender, _tokenId);
        nftLocked[_tokenId] = false;
        lockUpDeadline[_tokenId] = 0;
        withdrawTriggered[_tokenId] = false;
    }

    function collectLPFees(uint256 _tokenId) external onlyLPFeeCollector {
        positionManager.collect(
            INonfungiblePositionManager.CollectParams({
                tokenId: _tokenId,
                recipient: lpFeeCollector,
                amount0Max: type(uint128).max,
                amount1Max: type(uint128).max
            })
        );
    }

    function changeLPFeeCollector(address account) external onlyLPFeeCollector {
        require(account != address(0), "Address 0");
        lpFeeCollector = account;
    }
}
