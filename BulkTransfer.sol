// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Ownable {
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }

    function transferOwnership(address newOwner) onlyOwner public {
        require(newOwner != address(0), "Invalid new owner address");
        owner = newOwner;
    }

    function withdraw() onlyOwner public {
        (bool success,) = owner.call{value: address(this).balance}("");
        require(success, "Withdraw failed");
    }
}

contract BulkTransfer is Ownable {
    address[] public senders;

    event TokensTransferred(address indexed from, address[] indexed to, uint256 value);

    function transferStaticValue(address _tokenAddress, address[] memory _to, uint256 _value) external {
        require(_to.length > 0, "Empty recipient address array");
        require(_value > 0, "Transfer value must be greater than 0");

        IERC20 token = IERC20(_tokenAddress);
        uint256 tokenBalance = token.balanceOf(msg.sender);
        uint256 sumValue = _value * _to.length;
        require(tokenBalance >= sumValue, "Your token's balance is not enough");

        for (uint256 i = 0; i < _to.length; i++) {
            require(_to[i] != address(0), "Invalid recipient address");
            require(token.transferFrom(msg.sender, _to[i], _value), "Transaction failed");
        }

        emit TokensTransferred(msg.sender, _to, sumValue);

        senders.push(msg.sender);
    }

    function transferStaticValue(address[] memory _to, uint256 _value) external payable {
        require(_to.length > 0, "Empty recipient address array");
        require(_value > 0, "Transfer value must be greater than 0");

        uint256 sumValue = _value * _to.length;
        require(msg.value >= sumValue, "Insufficient amount provided");

        for (uint256 i = 0; i < _to.length; i++) {
            require(_to[i] != address(0), "Invalid recipient address");
            (bool success,) = _to[i].call{value: _value}("");
            require(success, "Transaction failed");
        }

        emit TokensTransferred(msg.sender, _to, sumValue);

        senders.push(msg.sender);
    }

    function transferDynamicValues(address _tokenAddress, address[] memory _to, uint256[] memory _values) external {
        require(_to.length > 0, "Empty recipient address array");
        require(_to.length == _values.length, "Addresses and values length mismatch");
        uint256 sumValue = _validateAndGetSumFromDynamicValues(_values);

        IERC20 token = IERC20(_tokenAddress);
        uint256 tokenBalance = token.balanceOf(msg.sender);
        require(tokenBalance >= sumValue, "Your token's balance is not enough");

         for (uint256 i = 0; i < _to.length; i++) {
             require(_to[i] != address(0), "Invalid recipient address");
             require(token.transferFrom(msg.sender, _to[i], _values[i]), "Transaction failed");
         }

        emit TokensTransferred(msg.sender, _to, sumValue);

        senders.push(msg.sender);
    }

    function transferDynamicValues(address[] memory _to, uint256[] memory _values) external payable {
        require(_to.length > 0, "Empty recipient address array");
        require(_to.length == _values.length, "Addresses and values length mismatch");

        uint256 sumValue = _validateAndGetSumFromDynamicValues(_values);
        require(msg.value >= sumValue, "Insufficient amount provided");

         for (uint256 i = 0; i < _to.length; i++) {
             require(_to[i] != address(0), "Invalid recipient address");
             (bool success,) = _to[i].call{value: _values[i]}("");
             require(success, "Transaction failed");
         }

        emit TokensTransferred(msg.sender, _to, sumValue);

        senders.push(msg.sender);
    }

    function _validateAndGetSumFromDynamicValues(uint256[] memory _values) internal pure returns (uint256) {
        uint256 sumValue = 0;

        for (uint256 i = 0; i < _values.length; i++) {
            require(_values[i] > 0, "Transfer value must be greater than 0");
            sumValue += _values[i];
        }

        return sumValue;
    }
}
