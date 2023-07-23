// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract Registry {
    // Create an array to store the addresses
    address[] public contractAddresses;

    // Event to be emitted when a new address is registered
    // event AddressRegistered(address indexed _address);

    // Function to register a new address
    function register(address _address) public {
        contractAddresses.push(_address);
        // emit AddressRegistered(_address);
    }

    // Function to get all registered addresses
    function getRegisteredAddresses() public view returns (address[] memory) {
        return contractAddresses;
    }
}