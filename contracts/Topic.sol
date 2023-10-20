// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import "contracts/Proposal.sol";

contract Topic {
    
    struct Voter {
        uint balance;   // how many votes they have left
        Proposal[] votedFor; //array of voted for proposals
        bool hasRequestedVote;//if hasn't requested vote, allows balance to become the standard alloted balance
    }

    mapping(address => Voter) public voters;
   
    string[] proposalTitles;
    mapping (string => address) public proposalAddressFromTitle;
    mapping(address => Proposal) public proposalFromAddress;
    
    //todo emit events
    constructor() {}

    function getUserBalance() public view returns(uint balance){
        return voters[msg.sender].balance;
    }
    function makeNewProposal(string memory _title) public {
        Proposal newProposal = new Proposal(_title);
        proposalAddressFromTitle[_title] = address(newProposal);
        proposalFromAddress[address(newProposal)] = newProposal;
        proposalTitles.push(_title);
    }

    function requestVote() public {
        if(! voters[msg.sender].hasRequestedVote){
            voters[msg.sender].balance = 50;
            voters[msg.sender].hasRequestedVote = true;
        }
    }

    function vote(string memory _proposalTitle,uint _amount) public checkProposalExists(_proposalTitle)  {
        require (voters[msg.sender].balance >= _amount, "have to have enough votes to send");
        proposalFromAddress[proposalAddressFromTitle[_proposalTitle]].giveVote(msg.sender,_amount);     
        voters[msg.sender].balance -= _amount;
    }

    function withdrawVote(string memory _proposalTitle,uint _amount) public{
        require(proposalFromAddress[proposalAddressFromTitle[_proposalTitle]].getVoterBalance(msg.sender) >= _amount, "can't withdraw what you haven't put in");
        proposalFromAddress[proposalAddressFromTitle[_proposalTitle]].withdrawVote(msg.sender, _amount);
        voters[msg.sender].balance += _amount;
    }

    modifier checkProposalExists(string memory _proposalTitle) {
        bool proposalExists = false;
        for(uint i = 0; i <= proposalTitles.length;i++){
            if( stringsEqual(_proposalTitle,proposalFromAddress[proposalAddressFromTitle[_proposalTitle]].getTitle())){
                proposalExists = true;
            }
        }
        require(proposalExists, "proposal does not exist");
            _;
    }

    function stringsEqual(string memory s1, string memory s2) private pure returns (bool) {
        bytes memory b1 = bytes(s1);
        bytes memory b2 = bytes(s2);
        uint256 l1 = b1.length;
        if (l1 != b2.length) return false;
        for (uint256 i=0; i<l1; i++) {
            if (b1[i] != b2[i]) return false;

        }
        return true;
    }

    function getWinningProposalName() public view returns (string memory winningProposalName){
        uint winningVoteCount = 0;

        for (uint p = 0; p < proposalTitles.length; p++) {
            if (proposalFromAddress[proposalAddressFromTitle[proposalTitles[p]]].getTotalVotes() > winningVoteCount) {
                winningVoteCount = proposalFromAddress[proposalAddressFromTitle[proposalTitles[p]]].getTotalVotes();
                winningProposalName = proposalTitles[p];
            }
        }
        return winningProposalName;
    }

    function winningProposalAddress() public view returns (address winnerAddress_){
        return proposalAddressFromTitle[getWinningProposalName()];
    }
}