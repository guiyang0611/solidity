// SPDX-License-Identifier: NFT
pragma solidity ^0.8;

import "@openzeppelin/contracts/access/Ownable.sol";

contract BeggingContract is Ownable{
   
   uint256 amount;
   // 捐赠记录：地址 => 金额
   mapping(address => uint256) public donations;
   // 捐赠排行榜（最多记录前 3 名）
   address[3] public topDonors;
   // 捐赠事件
   event Donation(address indexed donor, uint256 amount);
   //捐赠时间限制开始时间
   uint256 startTime;
   //捐赠时间限制结束时间
   uint256 endTime;

   constructor(uint256 _startTime, uint256 _endTime) Ownable(msg.sender) {
      startTime = _startTime;
      endTime = _endTime;
   }

   //允许用户向合约发送以太币，并记录捐赠信息
   function donate() external payable {
      //require(block.timestamp >= startTime, "Donation period not started");
      //require(block.timestamp <= endTime, "Donation period ended");
      require( msg.value > 0, "Donation amount must be greater than 0");
      donations[msg.sender] += msg.value;
      emit Donation(msg.sender, msg.value);
      updateTopDonors(msg.sender);
   }

    //提款函数（仅限所有者）
   function withdraw() external  onlyOwner {
       uint256 balance = address(this).balance;
       payable(owner()).transfer(balance);
   }

   //允许查询某个地址的捐赠金额
   function getDonation(address donor) external  view returns (uint256) {
        return donations[donor];
   }

   //获取排行榜信息
   function getTopDonors() external  view returns (address[3] memory) {
        return topDonors;
   }

   // 更新排行榜（可选功能）
   function updateTopDonors(address donor) private {
    uint256 value = donations[donor]; // 获取该用户的总贡献值

    // 如果已经在榜上了就直接返回
    for (uint256 i = 0; i < topDonors.length; i++) {
        if (topDonors[i] == donor) return; // 已在榜单中，无需重复添加
    }

    // 查找空位或者合适的位置插入
    for (uint256 i = 0; i < topDonors.length; i++) {
        if (topDonors[i] == address(0)) { // 如果有空槽位（即尚未填满三人）
            topDonors[i] = donor;         // 那么直接放进去就好了
            return;
        }

        // 比较当前元素的捐赠值与新候选人的大小关系
        if (value > donations[topDonors[i]]) {
            // 进行移位操作腾出空间给更大的值
            for (uint256 j = 2; j > 0; j--) {
                if (value > donations[topDonors[j - 1]]) {
                    topDonors[j] = topDonors[j - 1]; // 向后移动较小的元素
                } else {
                    topDonors[j] = donor;      // 找到合适位置插入新元素
                    return;
                }
            }
            topDonors[0] = donor;              // 如果比所有人都大，则放在第一位
            return;
        }
    }
}


}
