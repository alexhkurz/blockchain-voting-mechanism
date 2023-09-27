// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "contracts/Imports.sol";

contract Proposal {
    address creator;
    string title;
    string description;
    address topicAddress;
    int goal;//used if the solution wants people to send in money
    mapping(address => uint) public userBalance;

    constructor(string memory _proposalTitle, string memory _proposalDescription,_topicAddress){
        creator = msg.sender;
        title = _proposalTitle;
        description = _proposalDescription;
        topicAddress = _topicAddress;
    }

    receive() external payable{ // recieve votes from user
        userBalance[msg.sender] += msg.value;
    }

    modifier onlyOwner(){ // only owner can access function
        require(creator == msg.sender, "not owner");
        _;
    }
    function getTotalBalence() public view returns(uint){// returns total balance
        return address(this).balance;
    }

    function getUserBalence() public view returns(uint){// returns user balance
        return userBalance[msg.sender];
    }
    
    function withdraw(address _topicAddress, address _sender, uint _amount) external returns(uint){// returns user balance
        require(userBalance[msg.sender] >= _amount, "can't withdraw more then you have");
        IERC20 tokenContract = IERC20(topicAddress);
        tokenContract.transferFrom(address(this),_sender,_amount);
        userBalance[msg.sender] -= _amount;
        return userBalance[msg.sender];
    }

    function setDescription(string memory _description) onlyOwner public {
        require (msg.sender == creator, "must be creator to set description");
        description = _description;
    }

    function getDescription() view public returns (string memory){//returns description
        require (msg.sender == creator, "must be creator to set description");
        return description;
    }

    function setName(string memory _title) onlyOwner public {
        require (msg.sender == creator, "must be creator to set description");
        title = _title;
    }

    function getName() view public returns (string memory){// returns name
        require (msg.sender == creator, "must be creator to set description");
        return title;
    }

    function getThisAddress()public view returns(address){//returns this contract address
        return address(this);
    }

}