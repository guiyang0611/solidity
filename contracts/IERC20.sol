// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IERC20 {
    //当发生转账时触发的事件
    event Transfer(address indexed from, address indexed to, uint256 value);
    //当授权别人使用代币时触发的事件
    event Approval(address indexed owner, address indexed spender, uint256 value);
    //获取总发行量
    function totalSupply() external view returns (uint256);
    //查询某个地址的余额
    function balanceOf(address account) external view returns (uint256);
    //向某个地址转账
    function transfer(address to, uint256 amount) external returns (bool);
    //查询某个地址允许别人使用的额度（授权额度）
    function allowance(address owner, address spender) external view returns (uint256);
    //授权别人使用一定数量的代币
    function approve(address spender, uint256 amount) external returns (bool);
    //被授权者代为转账（代扣）
    function transferFrom(address from, address to, uint256 amount) external returns (bool);
}

contract SimpleERC20 is IERC20 {
    //代币名称
    string public name = "SimpleERC20";
    //代币符号
    string public symbol = "SERC";
    //小数位数，通常为 18，表示 1 个代币 = 1e18 最小单位
    uint8 public decimals = 18;
    //当前总发行量
    uint256 private _totalSupply;
    //每个地址的余额（address => balance）
    mapping(address => uint256) private _balances;
    //授权信息（owner => spender => amount）
    mapping(address => mapping(address => uint256)) private _allowances;
    //合约所有者地址，用于限制 mint 函数权限
    address public owner;

    constructor() {
        //将合约所有者设置为部署者（msg.sender）
        owner = msg.sender;
    }

    modifier onlyOwner() {
        // 函数修饰器（modifier），用于限制某些函数只能由合约所有者调用
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }
    //返回总发行量
    function totalSupply() public view override returns (uint256) {
        return _totalSupply;
    }
    //返回某个地址的余额
    function balanceOf(address account) public view override returns (uint256) {
        return _balances[account];
    }
    //实现转账功能
    function transfer(address to, uint256 amount) public override returns (bool) {
        //检查发送者余额是否足够
        require(balanceOf(msg.sender) >= amount, "Not enough balance");
        //扣除发送者余额，增加接收者余额
        _balances[msg.sender] -= amount;
        _balances[to] += amount;
        //触发 Transfer 事件记录转账行为
        emit Transfer(msg.sender, to, amount);
        return true;
    }
    //查询某个地址允许别人使用的额度
    function allowance(address ownerAddr, address spender) public view override returns (uint256) {
        return _allowances[ownerAddr][spender];
    }
    //设置授权额度
    function approve(address spender, uint256 amount) public override returns (bool) {
        _allowances[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }
    //实现代扣转账（被授权者使用）
    function transferFrom(address from, address to, uint256 amount) public override returns (bool) {
        uint256 allowed = allowance(from, msg.sender);
        //检查授权额度和余额是否足够
        require(allowed >= amount, "Allowance too low");
        require(balanceOf(from) >= amount, "Balance too low");
        //扣除授权额度和余额
        _balances[from] -= amount;
        //增加接收者余额
        _balances[to] += amount;
        _allowances[from][msg.sender] -= amount;
        //触发 Transfer 和 Approval 事件
        emit Transfer(from, to, amount);
        return true;
    }
    //mint(...) 是增发函数，用于铸造新的代币
    //只有合约所有者可以调用（使用 onlyOwner 修饰器
    //铸造的代币会发送给指定地址 to
    //增发时，from 地址是 address(0)，表示代币是“凭空产生”的
    function mint(address to, uint256 amount) public onlyOwner {
        _totalSupply += amount;
        _balances[to] += amount;
        //触发 Transfer 事件记录增发行为
        emit Transfer(address(0), to, amount);
    }
}