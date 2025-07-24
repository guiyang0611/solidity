// SPDX-License-Identifier: NFT
pragma solidity ^0.8;

contract Reverse {
   
     function reverseStr(string memory str) public pure  returns (string memory) {
        bytes memory data = bytes(str);
        uint len = data.length;
        bytes memory newData = new bytes(len);
        for (uint i = 0; i < len; i++) {
            newData[i] = data[len - i - 1];
        }
        return string(newData);
     }
  
}
