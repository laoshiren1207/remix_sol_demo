// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title Laoshiren Transfer Coin
 * @dev Implementation of a simple ERC-20 token with additional transfer features
 */
contract LaoshirenTransferCoin {
    // 合约所有者
    address public owner;
    
    // 代币名称
    string public name = "Laoshiren Coin";
    // 代币符号
    string public symbol = "LSC";
    // 小数位数
    uint8 public decimals = 18;
    // 总供应量
    uint256 public totalSupply;

    // 余额映射
    mapping(address => uint256) public balanceOf;
    // 授权映射
    mapping(address => mapping(address => uint256)) public allowance;

    // 转账事件
    event Transfer(address indexed from, address indexed to, uint256 value);
    // 授权事件
    event Approval(address indexed owner, address indexed spender, uint256 value);

    /**
     * @dev 构造函数
     * @param initialSupply 初始供应量
     */
    constructor(uint256 initialSupply) {
        owner = msg.sender;
        totalSupply = initialSupply * 10 ** uint256(decimals);
        balanceOf[msg.sender] = totalSupply;
    }
    
    /**
     * @dev 修饰器，检查调用者是否为合约所有者
     */
    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }

    /**
     * @dev 转账函数
     * @param to 接收地址
     * @param value 转账金额
     * @return success 是否成功
     */
    function transfer(address to, uint256 value) public returns (bool success) {
        require(to != address(0), "Invalid address");
        require(balanceOf[msg.sender] >= value, "Insufficient balance");

        balanceOf[msg.sender] -= value;
        balanceOf[to] += value;

        emit Transfer(msg.sender, to, value);
        return true;
    }

    /**
     * @dev 授权函数
     * @param spender 被授权地址
     * @param value 授权金额
     * @return success 是否成功
     */
    function approve(address spender, uint256 value) public returns (bool success) {
        require(spender != address(0), "Invalid address");

        allowance[msg.sender][spender] = value;

        emit Approval(msg.sender, spender, value);
        return true;
    }

    /**
     * @dev 授权转账函数
     * @param from 转出地址
     * @param to 转入地址
     * @param value 转账金额
     * @return success 是否成功
     */
    function transferFrom(address from, address to, uint256 value) public returns (bool success) {
        require(from != address(0) && to != address(0), "Invalid address");
        require(balanceOf[from] >= value, "Insufficient balance");
        require(allowance[from][msg.sender] >= value, "Insufficient allowance");

        balanceOf[from] -= value;
        balanceOf[to] += value;
        allowance[from][msg.sender] -= value;

        emit Transfer(from, to, value);
        return true;
    }

    /**
     * @dev 铸造新代币（仅所有者可调用）
     * @param to 接收地址
     * @param value 铸造金额
     */
    function mint(address to, uint256 value) public onlyOwner {
        require(to != address(0), "Invalid address");
        totalSupply += value;
        balanceOf[to] += value;
        emit Transfer(address(0), to, value);
    }

    /**
     * @dev 销毁代币
     * @param value 销毁金额
     */
    function burn(uint256 value) public {
        require(balanceOf[msg.sender] >= value, "Insufficient balance");
        totalSupply -= value;
        balanceOf[msg.sender] -= value;
        emit Transfer(msg.sender, address(0), value);
    }
}
