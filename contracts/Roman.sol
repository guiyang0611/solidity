// SPDX-License-Identifier: NFT
pragma solidity ^0.8;

contract Roman {

    function romanToInt(string memory str) public pure returns (uint) {
        bytes memory data = bytes(str);
        uint len = data.length;
        uint total = 0;
        uint i = 0;
        while (i < len) {
           if (i+ 1 < len){
                uint pair = getPairValue(data[i],data[i+1]);
                if(pair != 0){
                    total += pair;
                    i += 2;
                    continue;
                }
           }   
            total += getSingleValue(data[i]);
            i++;
        }
        return total;
    }

    function intToRoman(uint num) public pure returns (string memory) {
        require(num > 0 && num < 4000, "Input must be between 1 and 3999");

        uint[13] memory values = [uint(1000), 900, 500, 400, 100, 90, 50, 40,10, 9, 5, 4,1];

        string[13] memory symbols = [
            "M", "CM", "D", "CD",
            "C", "XC", "L", "XL",
            "X", "IX", "V", "IV",
            "I"
        ];

        uint i = 0;
        string memory result = "";

        while (num > 0) {
            if (num >= values[i]) {
                result = string.concat(result, symbols[i]);
                num -= values[i];
            } else {
                i++;
            }
        }

        return result;
    }

    function getSingleValue(bytes1 s) internal pure returns (uint) {
         if (s == 'I') return 1;
         if (s == 'V') return 5;
         if (s == 'X') return 10;
         if (s == 'L') return 50;
         if (s == 'C') return 100;
         if (s == 'D') return 500;
         if (s == 'M') return 1000;
         revert("Invalid Roman numeral");
    }

    function getPairValue(bytes1 a, bytes1 b) internal pure returns (uint) {
         if (a == 'I' && b == 'V') return 4;
         if (a == 'I' && b == 'X') return 9;
         if (a == 'X' && b == 'L') return 40;
         if (a == 'X' && b == 'C') return 90;
         if (a == 'C' && b == 'D') return 400;
         if (a == 'C' && b == 'M') return 900;
         return 0;
    }
  
}
