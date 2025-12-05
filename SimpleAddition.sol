// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title SimpleAddition
 * @dev 一个执行加法运算的简单智能合约
 */
contract SimpleAddition {

    /**
     * @dev 将两个无符号整数相加
     * @param a 第一个加数
     * @param b 第二个加数
     * @return result 两数之和
     */
    function add(uint256 a, uint256 b) public pure returns (uint256 result) {
        // Solidity 0.8.0 版本后默认开启溢出检查
        // 如果 a + b 的结果超出 uint256 的最大范围，交易将失败并回滚
        result = a + b;
    }

    /**
     * @dev 将两个无符号整数相加，并返回两个值：和 以及 是否发生了溢出（未发生溢出）
     *      这展示了如何显式处理潜在的溢出而不让交易失败
     * @param a 第一个加数
     * @param b 第二个加数
     * @return sum 两数之和
     * @return isOverflow 是否发生溢出 (在这个函数中，由于使用了 unchecked，需要手动检查)
     */
    function addWithOverflowCheck(uint256 a, uint256 b) public pure returns (uint256 sum, bool isOverflow) {
        // 使用 unchecked 块禁用默认的溢出检查，以便我们手动检测
        unchecked {
            sum = a + b;
            // 检查是否发生溢出: 如果 sum < a (或者 sum < b)，则说明加法结果回绕了
            isOverflow = (sum < a); // 或者 isOverflow = (sum < b);
        }
    }
}