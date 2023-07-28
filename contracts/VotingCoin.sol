
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "../lib/ERC20.sol";
contract BasicVotingTokenZepplin is ERC20{
    address[] hasVoted;
    constructor() ERC20("BasicVotingTokenZepplin", "MTK") {}

    function requestToken() public {
        require(isNewVoter(msg.sender) == true,"can't vote twice");
        hasVoted.push(msg.sender);
        _mint(msg.sender,5);
    
    }
    
    function isNewVoter(address potentialVoter) public view returns (bool){

        for(uint i =0; i < (hasVoted.length);i++){
            if(potentialVoter == hasVoted[i]){
                return false;
            }
        }
        return true;
    }
     function mint(address to, uint256 amount) public {
        _mint(to, amount);
    }
}

    /*
    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }

    */
   
    /*
    function _beforeTokenTransfer(address from, address to, uint256 amount)
        internal
        whenNotPaused
        override
    {
        super._beforeTokenTransfer(from, to, amount);
    }
    */
