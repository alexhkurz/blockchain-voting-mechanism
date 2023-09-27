Functionality:

Voting token:
each topic creates a new voting token with a name based off of the name of the token. Each proposal will only accept token from the topic. (will impliment a numbering system in the future to prevent identical naming).

recieving new voting token:
requestToken() disburses 5 token to a user if they had not previously recieved token. The user addresses are stored in "list of voters"

deploying proposals:
makeNewProposal() creates a new proposal address which can then recieve and send vote tokens upon request of the user. 
Each proposal is just a "shell" without any real functionality (so far). Main requirement is to recieve and return token to voters. It recieves via the built in solidity recieve() function, although that is currently buggy and not recieving the erc20 token properly. It can also change description text etc(in the future, I want to make the information static before allowing votes to come in).

sending token: 
use the erc20 transfer function (transferFrom has been removed as we don't want people voting for other people!)

withdrawing token:
withdrawFromProposal passes an amount to the proposal and calls the proposals withdraw function.

*note: we have proposals as seperate contracts instead of integrated with the main contract as we want the ability for future things to be done with the smart contract, ie it acting as a typical smart contract that will act in a way once conditions are fulfilled. Also modularity. 

Funciton by function workings: 

 function makeNewProposal
    takes: string memory _name,string memory _description
    creates a new proposaland appends its address to the map of addresses and proposals, saves its address in a list of addresses.
    returns the address of the created proposal.
    
    
function getallProposals() 
no inputs,
returns listOfProposalAddresses

    function withdrawFromProposal
    takes: address proposalAddr,uint _amount
    Specifics: requires that a user has sent token to a proposal in order to take it out
    Withdraws from the proposal, and sends to user
       calls proposals[proposalAddr].withdraw(topicAddress, msg sender, amount requesting to withdraw);
    returns: nothing

function requestToken() isNewVoter
    no inputs
    checks that the message sender has not requested before
    adds user to list of requested people
    mints 5 new token
    no returns


function mint(address to, uint256 amount) private isNewVoter 
Standard ledzepplin mint, requireing that the person is a new ver
no returns, private


modifier isNewVoter 
requires that msg.sender is not in the list of people who have voted

Proposal functions
 
receive() external payable
    no inputs
    uses premade implimentation of recieve, incriments user balance
    no returns

function withdraw
inputs: address _topicAddress, address _sender, uint _amount
    requires user balance to be >= amount invested   
    uses openzepplin token transfer
    returns post withdrawal userBalance[msg.sender];



# Sample Hardhat Project

This project demonstrates a basic Hardhat use case. It comes with a sample contract, a test for that contract, and a script that deploys that contract.

Try running some of the following tasks:

```shell
npx hardhat help
npx hardhat test
REPORT_GAS=true npx hardhat test
npx hardhat node
npx hardhat run scripts/deploy.js
```
