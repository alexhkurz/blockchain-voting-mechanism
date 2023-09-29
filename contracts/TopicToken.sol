// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "contracts/Imports.sol";

contract TopicToken is ERC20, Ownable{
    string title;
    address addr;

    constructor(string memory _title, string memory _abreviation) ERC20(_title,_abreviation){}
    
    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }
}