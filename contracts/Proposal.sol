// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;
contract Proposal {
    // If you can limit the length to a certain number of bytes, 
    // always use one of bytes1 to bytes32 because they are much cheaper
    string title;   // short name (up to 32 bytes)
    constructor(string memory _title) {title=_title;}
    uint public voteCount; // number of accumulated votes
    mapping(address => uint) voterBalances;

    function getVoterBalance(address sender)public view returns(uint voterBalance){
 
        return voterBalances[sender];
    
    }
    function getTotalVotes()public view returns(uint voteCount_){
        return voteCount;
   
    }

    function withdrawVote(address sender, uint _amount) public {
        voterBalances[sender] -= _amount;
        voteCount -=_amount;
    }

    function giveVote(address sender,uint _amount) payable  public {
        voterBalances[sender] += _amount;// this is the line it is breaking
        voteCount+=_amount;
    }

    function getTitle() public view returns(string memory title_){
        return title;
    }
}