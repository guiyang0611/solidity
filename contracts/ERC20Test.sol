// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol"; 
import "@openzeppelin/contracts/access/Ownable.sol";

contract ERC20Test is ERC20, Ownable {
     
   constructor() ERC20("ERC20Test","ERC") Ownable(msg.sender)  {
        _mint(msg.sender, 1000 * 10 ** decimals());
   }

   
   function mint(address to ,uint amount) public onlyOwner {
          _mint(to, amount);
   }
   
   function approveAddress(address spender ,uint amount) public returns (bool) {
         require(balanceOf(msg.sender) > amount, "Not enough balance ");
         approve(spender, amount);
         return true;
   }

   function transferAmount(address to, uint256 amount) public returns (bool) {
         require(balanceOf(msg.sender) > amount, "Not enough balance");
         transfer(to, amount);
         return true;
   }

    function transferFromAmount(address from, address to, uint256 amount) public returns (bool) {
         require(allowance(msg.sender, to) > amount, "Not enough balance");
         transferFrom(from, to, amount);
         return true;
   }  

    function queryAccount(address account) public view returns (uint256) {
         return balanceOf(account);
   }  

}
