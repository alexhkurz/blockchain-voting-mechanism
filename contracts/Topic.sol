// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "contracts/Proposal.sol";

contract Topic is ERC20, Ownable {
    string title;
    string description;

    mapping(address => Proposal) public proposals;
    address[] listOfProposalAddresses;
    address[] listOfVoters;

    enum conclude_vote_types{time,threshold}
    enum voting_mode_types{firstPastThePost,runoff_twoRound, rankedChoice,distruibuted,distributed_ranked_choice}
    conclude_vote_types concludeVoteMode = conclude_vote_types.time;
    voting_mode_types votingMode = voting_mode_types.distributed_ranked_choice;
    
    constructor(string memory _topicTitle, string memory _topicDescription) ERC20("Topic_Token", "TTK"){
        title = _topicTitle;
        description = _topicDescription;
    }
    
    //proposal stuff
    function makeNewProposal(string memory _name,string memory _description)public returns (address){
        Proposal newProposal = new Proposal(_name,_description,this.address);
        proposals[address(newProposal)] = newProposal;
        listOfProposalAddresses.push(address(newProposal));
        return address(newProposal);
    }

    function getallProposals() public view returns(address[] memory){
        return listOfProposalAddresses;
    }

    //proposal transaction stuff
    function withdrawFromProposal(address proposalAddr,uint _amount) public {
        require(proposals[proposalAddr].getUserBalence() > 0, "can't take nothing");
        proposals[proposalAddr].withdraw(address(this),msg.sender,_amount);
    }

    function requestToken() isNewVoter public {
        listOfVoters.push(msg.sender);
        _mint(msg.sender,5);
    }

    function mint(address to, uint256 amount) private isNewVoter {
        _mint(to, amount);
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
