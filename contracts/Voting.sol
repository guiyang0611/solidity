// SPDX-License-Identifier: NFT
pragma solidity ^0.8;

contract Voting {
   
   mapping(string => uint256) public votesMap;
   string[] public allUsers;
   event Voted(address voters, string addr);

   function vote(string memory addr) public {
        uint256 count = votesMap[addr];
         if (count == 0 && !contains(allUsers, addr)){
           allUsers.push(addr);
        }
        count++;
        votesMap[addr] = count;
        emit Voted(msg.sender, addr);
   }

   function getVotes(string memory addr) public view returns (uint256) {
         return votesMap[addr];
   }

    function resetVotes() public {
       for(uint i = 0; i < allUsers.length; i++) {
           votesMap[allUsers[i]] = 0;
       }
   }

   // 检查数组是否包含某个字符串
    function contains(string[] memory arr, string memory value) internal pure returns (bool) {
        for (uint i = 0; i < arr.length; i++) {
            if (keccak256(bytes(arr[i])) == keccak256(bytes(value))) {
                return true;
            }
        }
        return false;
    }
  
}
