// SPDX-License-Identifier: NFT
pragma solidity ^0.8;

contract BinarySearch {

     uint[] private nums = [ 1, 2, 3, 4, 5, 6,7,8,9,10];

    function search(uint target) public view returns (int) {
        uint left = 0;
        uint right = nums.length - 1;

        while (left <= right) {
            uint mid = (left + right) / 2;
            if (nums[mid] == target) {
                return int(mid);
            } else if (nums[mid] < target) {
                left = mid + 1;
            } else {
                right = mid - 1;
            }
        }

        return -1; // 未找到
    }
  
}
