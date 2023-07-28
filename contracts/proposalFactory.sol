// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "./proposal.sol";

contract ProposalFactory{
    Proposal[] public proposals;

    function makeNewProposal(string memory _name,string memory _description)public{
      proposals.push(new Proposal(_name,_description));
    }

   function allProposal() public view returns(Proposal[] memory){
       return proposals;
   }
}
