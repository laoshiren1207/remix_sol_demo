// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20; // 使用较新的 Solidity 版本

// 导入 OpenZeppelin 的 ERC20 实现，它已经符合 ERC-20 标准
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

/**
 * @title MyToken
 * @dev A simple ERC20 token example.
 */
contract LaoshirenToken is ERC20 {
    /**
     * @dev Constructor that gives the deployer all of the initial tokens.
     * @param name_ The name of the token.
     * @param symbol_ The symbol of the token.
     * @param initialSupply The total initial supply of tokens (in the smallest unit).
     */
    constructor(
        string memory name_,
        string memory symbol_,
        uint256 initialSupply
    ) ERC20(name_, symbol_) { // 调用父合约 ERC20 的构造函数
        // 将全部初始供应量铸造给部署合约的账户 (msg.sender)
        _mint(msg.sender, initialSupply);
    }
}