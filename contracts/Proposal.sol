// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;
contract Proposal {
    address creator;
    mapping(address => uint) userBalance;
    string title;
    string description;
    int goal;//used if the solution wants people to send in money

    
    constructor(string memory _title, string memory _description){
        creator = msg.sender;
        title = _title;
        description = _description;
    }

    receive() external payable{
        userBalance[msg.sender] += msg.value;
    }

    function withdraw(uint _amount) external {
        require(userBalance[msg.sender] > 0, "can't take nothing");
        userBalance[msg.sender] -= _amount;
        payable(msg.sender).transfer(_amount);
    }

    function getTotalBalence() external view returns(uint){
        return address(this).balance;
    }

    function getUserBalence() external view returns(uint){
        return userBalance[msg.sender];
    }

    function setDescription(string memory _description) public {
        require (msg.sender == creator, "must be creator to set description");
        description = _description;
    }

    function getDescription() view public returns (string memory){
        require (msg.sender == creator, "must be creator to set description");
        return description;
    }

    function setName(string memory _title) public {
        require (msg.sender == creator, "must be creator to set description");
        title = _title;
    }

    function getName() view public returns (string memory){
        require (msg.sender == creator, "must be creator to set description");
        return title;
    }

    function getThisAddress()public view returns(address){
        return address(this);
    }

}