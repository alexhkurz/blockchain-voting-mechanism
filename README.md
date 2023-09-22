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
