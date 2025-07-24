// SPDX-License-Identifier: NFT
pragma solidity ^0.8;

contract MergeSortedArray {

    function mergeSortedArray(uint[] memory nums1, uint[] memory nums2) public pure returns (uint[] memory) {
        uint len1 = nums1.length;
        uint len2 = nums2.length;
        uint[] memory result = new uint[](len1 + len2);

        uint i = 0;
        uint j = 0;
        uint k = 0;

        while (i < len1 && j < len2) {
            if (nums1[i] < nums2[j]) {
                result[k++] = nums1[i++];
            } else {
                result[k++] = nums2[j++];
            }
        }

        while (i < len1) {
            result[k++] = nums1[i++];
        }

        while (j < len2) {
            result[k++] = nums2[j++];
        }

        return result;
    }
  
}
