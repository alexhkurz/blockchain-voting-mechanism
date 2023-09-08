// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

//instead of using erc20, just make everything in house and emit whenever someone requests coin or sends to proposal. 
import "./Proposal.sol";

import "@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/extensions/ERC20BurnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/security/PausableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

contract Topic is Initializable, ERC20Upgradeable, ERC20BurnableUpgradeable, PausableUpgradeable, OwnableUpgradeable {
    //want to be able to make multiple different topics, and even in the future a proposal contract that is a topic with proposals, where if that topic wins then the next vote is which of it's proposals etc
   
    string title;
    string description;

    mapping(address => Proposal) public proposals;
    address[] listOfProposalAddresses;
    address[] listOfVoters;

    enum conclude_vote_types{time,threshold}
    enum voting_mode_types{firstPastThePost,runoff_twoRound, rankedChoice,distruibuted,distributed_ranked_choice}
    conclude_vote_types concludeVoteMode = conclude_vote_types.time;
    voting_mode_types votingMode = voting_mode_types.distributed_ranked_choice;
    
    constructor(string memory _topicTitle, string memory _topicDescription) {
       
        initialize(_topicTitle,_topicDescription);
        //_disableInitializers();
    }
    
    function requestToken() isNewVoter public {
        listOfVoters.push(msg.sender);
        _mint(msg.sender,5);
    }

    //proposal stuff
    function makeNewProposal(string memory _name,string memory _description)public returns (address){
        Proposal newProposal = new Proposal(_name,_description);
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
        proposals[proposalAddr].withdraw(address(this),_amount);
    }
    
    //token other stuff
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

    function initialize(string memory _title,string memory _description) initializer internal {
        title = _title;
        description = _description;
        __ERC20_init(string(abi.encodePacked(_title,"_VoteToken")), string(abi.encodePacked(_title,"_VT")));// VT = VoteToken
        __ERC20Burnable_init();
        __Pausable_init();
        __Ownable_init();
    }

    //untouched openZeppelin code
    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }

    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }

    function _beforeTokenTransfer(address from, address to, uint256 amount)
        internal
        whenNotPaused
        override
    {
        super._beforeTokenTransfer(from, to, amount);
    }
}
