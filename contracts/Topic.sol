// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "contracts/Proposal.sol";
import "contracts/Imports.sol";

contract Topic {
   
    string title;
    string description;
    address topicAddress;

    TopicToken token;
    
    mapping(address => Proposal) public proposals;
    address[] listOfProposalAddresses;
    address[] listOfVoters;

    enum conclude_vote_types{time,threshold}
    enum voting_mode_types{firstPastThePost,runoff_twoRound, rankedChoice,distruibuted,distributed_ranked_choice}
    conclude_vote_types concludeVoteMode = conclude_vote_types.time;
    voting_mode_types votingMode = voting_mode_types.distributed_ranked_choice;
    
    constructor(string memory _topicTitle, string memory _topicDescription) {
        title = _topicTitle;
        description = _topicDescription;
        topicAddress = address(this);
        token = new TopicToken("Topic_Token", "TTK");
    }
    
    //proposal stuff
    function makeNewProposal(string memory _name,string memory _description)public returns (address){
        Proposal newProposal = new Proposal(_name,_description,token);
        proposals[address(newProposal)] = newProposal;
        listOfProposalAddresses.push(address(newProposal));
        return address(newProposal);
    }

    function getallProposals() public view returns(address[] memory){
        return listOfProposalAddresses;
    }

    function sendToProposal(address _proposalAddr,uint _amount) proposalExists(_proposalAddr) public {
        require(token.balanceOf(msg.sender) >= _amount, "can't give more than ya have");
        token.approve(msg.sender, _amount);
        token.transferFrom(msg.sender, _proposalAddr, _amount);
        console.log("sent token: ");
        console.log(_amount);
    }

    //proposal transaction stuff
    function getUserBalance() public view returns(uint){
        return token.balanceOf(msg.sender);
    }
    function getTotalSupply() public view returns(uint){
        return token.totalSupply();
    }
    function withdrawFromProposal(address _proposalAddr,uint _amount) proposalExists(_proposalAddr) public {
        require(proposals[_proposalAddr].getUserBalence() > 0, "can't take nothing");
        proposals[_proposalAddr].withdraw(msg.sender,_amount);
    }

    function requestToken() isNewVoter public {
        listOfVoters.push(msg.sender);
        token.mint(msg.sender,5);
    }

    modifier proposalExists(address _proposalAddr){
        bool propExists = false;
        for(uint i = 0; i < listOfProposalAddresses.length; i++){
            if(_proposalAddr == listOfProposalAddresses[i]){
                propExists = true;
            }
        }
        require(propExists == true, "proposal address not valid");
        _;

    }
    modifier isNewVoter {
        bool canVote = true;

        for(uint i =0; i < (listOfVoters.length);i++){
            if(msg.sender == listOfVoters[i]){
                canVote = false;
            }
        }
        
        require(canVote == true,"not a new voter");
        _;
    }
    
}

