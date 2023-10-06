// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

// 1st import as follows
import "contracts/Imports.sol";

contract Proposal {
    address creator;
    string title;
    string description;
    address topicAddress;
    TopicToken token;

    uint goal;//used if the solution wants people to send in money
    mapping(address => uint) public userBalance;
    
    event transferRecieved(address from, uint amount); 
    constructor(string memory _proposalTitle, string memory _proposalDescription, address _topicAddress, TopicToken _token) payable{
        creator = msg.sender;
        title = _proposalTitle;
        description = _proposalDescription;
        topicAddress = _topicAddress;
        token = _token;
    }
    
// recieve is not being called on transaction to this proposal
    receive() payable external { // recieve votes from user
       //does not check it is the right token yet
       emit transferRecieved(msg.sender, msg.value);
        userBalance[msg.sender] += msg.value;
        console.log("recieved token: ");
        console.log(msg.value);
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
    
    function withdraw(address _sender, uint _amount) external payable returns(uint){// returns user balance
        //does not yet check request is through parent topic
        //require(userBalance[msg.sender] >= _amount, "can't withdraw more then you have");
       
        userBalance[msg.sender] -= _amount;
        token.approve(address(this), _amount);
        token.transferFrom(address(this),payable(_sender), _amount);
        return userBalance[msg.sender];
    }

    function setDescription(string memory _description) onlyOwner public {
        require (msg.sender == creator, "must be creator to set description");
        description = _description;
    }

    function getDescription() public view returns (string memory){//returns description
        return description;
    }

    function setName(string memory _title) onlyOwner public {
        require (msg.sender == creator, "must be creator to set description");
        title = _title;
    }

    function getName() view public returns (string memory){// returns name
        return title;
    }

    function getThisAddress()public view returns(address){//returns this contract address
        return address(this);
    }

}