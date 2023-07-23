// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract Proposal {
    // State variables for the proposal
    string public title;
    string public descriptionURL;

    // Function to create a new proposal
    function createProposal(string memory _title, string memory _descriptionURL) public {
        title = _title;
        descriptionURL = _descriptionURL;
    }

    // Function to get the current proposal
    function getProposal() public view returns (string memory, string memory) {
        return (title, descriptionURL);
    }
}