//we change allowance and transfer things back and forth with different values to see if we can track what is happening.
//dispite everything, we are unable to make any changes to the users allowance.
//this inability to increase userr allowance means that the user can not transfer to anything
//however, we can easily change the topic's allowance. A work around may be to always have the 
//topic transfer tokens, keeping track of each user. The user wouldn't actually have the tokens at all, just telling the topic when to transfer.


// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

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


    //proposal transaction stuff
    function getUserBalance() public view returns(uint){
        return token.balanceOf(msg.sender);
    }
    function getTotalSupply() public view returns(uint){
        return token.totalSupply();
    }
    function withdrawFromProposal(address _proposalAddr,uint _amount) proposalExists(_proposalAddr) public {
        
        //require(proposals[_proposalAddr].getUserBalence() > 0, "cant take nothing");
        token.approve(_proposalAddr, _amount);
        token.approve(msg.sender, _amount);
        proposals[_proposalAddr].withdraw(msg.sender,_amount);
        
        //token.decreaseAllowance(_proposalAddr, _amount);
        //token.increaseAllowance(payable(msg.sender), _amount);
        emit withdrawFromProposalOnTopicSide(msg.sender,_proposalAddr,_amount);
    }

    function sendToProposal(address _proposalAddr,uint _amount) proposalExists(_proposalAddr) public {
        require(token.balanceOf(msg.sender) >= _amount, "cant give more than ya have");
        address senderAddress = address(msg.sender);
        //token.approve(msg.sender, _amount);
        
        //token.increaseAllowance(_proposalAddr,_amount);//get rid of one of these, approve isn't working as it should
        //token.decreaseAllowance(payable(msg.sender), 5);
        //token.Transfer(from, to, value);
        
        //token.transferFrom(msg.sender, _proposalAddr, _amount);
        console.log("topic allowance");
        console.log(token.allowance(address(this), address(this)));
        
        console.log("topic balance");
        console.log(token.balanceOf(address(this)));
        
        console.log("user allowance");
        console.log(token.allowance(senderAddress,senderAddress));
        
        console.log("user balance");
        console.log(token.balanceOf(senderAddress));

        console.log("proposal allowance");
        console.log(token.allowance(_proposalAddr,_proposalAddr));
        
        console.log("proposal balance");
        console.log(token.balanceOf(_proposalAddr));
               

        token.approve(senderAddress, 1 * 10**uint(token.decimals()));

        token.approve(topicAddress,2 * 10**uint(token.decimals()));
        token.approve(address(this),3 * 10**uint(token.decimals()));
        token.increaseAllowance(senderAddress, 1000);
        token.increaseAllowance(address(this), 2000);
        
        token.approve(senderAddress, 999999);
        //token.transferFrom(msg.sender, _proposalAddr, 5);
     //   console.log("usr address: ");
     //   console.log(msg.sender);

        console.log("AFTER TRANSFER: ----------------------------------------------------------");
        console.log("topic allowance");
        console.log(token.allowance(address(this), address(this)));
        
        console.log("topic balance");
        console.log(token.balanceOf(address(this)));
        
        console.log("user allowance");
        console.log(token.allowance(senderAddress,senderAddress));
        
        console.log("user balance");
        console.log(token.balanceOf(senderAddress));

        console.log("proposal allowance");
        console.log(token.allowance(_proposalAddr,_proposalAddr));
        
        console.log("proposal balance");
        console.log(token.balanceOf(_proposalAddr));
        emit transferSent(msg.sender, _proposalAddr, _amount);
        
        
    }

    function requestToken() isNewVoter public {
        listOfVoters.push(msg.sender);
       
        
       //token.mint(msg.sender,5);
        token.mint(address(this), 100 * 10**uint(token.decimals()));//;
        token.approve(msg.sender, 5 * 10**uint(token.decimals()));

        token.increaseAllowance(msg.sender, 200);
        token.increaseAllowance(address(this),200);

        token.approve(topicAddress,6 * 10**uint(token.decimals()));
        token.approve(address(this),7 * 10**uint(token.decimals()));
        token.transferFrom(address(this),msg.sender, 4 * 10**uint(token.decimals()));
        //token.transfer(msg.sender, 5 * 10**uint(token.decimals()));
        
        
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

