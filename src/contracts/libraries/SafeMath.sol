// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

library SafeMath {

    function add(uint256 x, uint256 y) internal pure returns(uint256) {
        uint256 r = x + y;
        require(r >= x, 'SafeMath: Addition Overflow');
        return r;
    }

    function sub(uint256 x, uint256 y) internal pure returns(uint256) {
        require(y <= x, 'SafeMath: Subtraction Overflow');
        return x - y;
    }

    function multiply(uint256 x, uint256 y) internal pure returns(uint256) {
        // gas optimization
        if (x == 0) {
            return 0;
        }
        uint256 r = x * y;
        require(r / x == y, 'SafeMath: Multiplication Overflow');
        return r;
    }

    function division(uint256 x, uint256 y) internal pure returns(uint256) {
        require(y > 0, 'SafeMath: Division by zero');
        return x / y;
    }

    function modulo(uint256 x, uint256 y) internal pure returns(uint256) {
        require(y != 0, 'SafeMath: Modulo division by zero');
        return x % y;
    }

}