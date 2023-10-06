// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "contracts/Proposal.sol";
import "contracts/Imports.sol";

contract Topic {
   
    string title;
    string description;
    address topicAddress;

    TopicToken token;
    
    mapping(address => Proposal) proposals;
    address[] listOfProposalAddresses;
    address[] listOfVoters;

    enum conclude_vote_types{time,threshold}
    enum voting_mode_types{firstPastThePost,runoff_twoRound, rankedChoice,distruibuted,distributed_ranked_choice}
    conclude_vote_types concludeVoteMode = conclude_vote_types.time;
    voting_mode_types votingMode = voting_mode_types.distributed_ranked_choice;
    
    event transferSent(address _from, address _destAddr, uint _amount); 
    event withdrawFromProposalOnTopicSide(address person, address fromProposal, uint amount);
   
    constructor(string memory _topicTitle, string memory _topicDescription) {
        title = _topicTitle;
        description = _topicDescription;
        topicAddress = address(this);
        token = new TopicToken("Topic_Token", "TTK");
    }
    
    //proposal stuff
    function makeNewProposal(string memory _name,string memory _description)public returns (address){
        Proposal newProposal = new Proposal(_name,_description,topicAddress, token);
        proposals[address(newProposal)] = newProposal;
        listOfProposalAddresses.push(address(newProposal));
        return address(newProposal);
    }

    function getallProposals() public view returns(address[] memory){
        return listOfProposalAddresses;
    }

    function getProposalDescription(address _proposalAddr) public view returns(string memory){
       return proposals[_proposalAddr].getDescription();
    }
    function getProposalName(address _proposalAddr) public view returns(string memory){
       return proposals[_proposalAddr].getName();
    }

    function sendToProposal(address _proposalAddr,uint _amount) proposalExists(_proposalAddr) public {
        require(token.balanceOf(msg.sender) >= _amount, "can't give more than ya have");
        token.approve(msg.sender, _amount);
        //token.increaseAllowance(_proposalAddr,_amount);//get rid of one of these, approve isn't working as it should
        //token.decreaseAllowance(payable(msg.sender), 5);
        
        token.transferFrom(payable(msg.sender), _proposalAddr, _amount);
        emit transferSent(msg.sender, _proposalAddr, _amount);
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
    function withdrawFromProposal(address _proposalAddr,uint _amount) proposalExists(_proposalAddr) public payable {
        
        //require(proposals[_proposalAddr].getUserBalence() > 0, "can't take nothing");
        token.approve(_proposalAddr, _amount);
        proposals[_proposalAddr].withdraw(payable(msg.sender),_amount);
        //token.decreaseAllowance(_proposalAddr, _amount);
        //token.increaseAllowance(payable(msg.sender), _amount);
        emit withdrawFromProposalOnTopicSide(msg.sender,_proposalAddr,_amount);
    }

    function requestToken() isNewVoter public {
        listOfVoters.push(payable(msg.sender));
        token.approve(payable(msg.sender), 5);
        //token.increaseAllowance(payable(msg.sender), 5);
        token.mint(msg.sender,5 * 10**uint(token.decimals()));
    }

    function getTokenAddress() public view  returns (TopicToken){
        return token;
    }
    modifier proposalExists(address _proposalAddr){
        bool propExists = false;
        for(uint i = 0; i < listOfProposalAddresses.length; i++){
            if(_proposalAddr == listOfProposalAddresses[i]){
                propExists = true;
                break;
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

