
---

(... ongoing as of Sep 14 ...)

Overall goal: Voting system. Transfer tokens (which represent votes). 
Every person who goes to a topic gets a set amount of tokens (there is limit on how many tokens a person can get).
Persons are able to interact with each proposal (can take back tokens, etc).
Every topic has its own token.

- Topic.sol
    - create topic
    - `makeNewProposal()`
    - `requestToken()` getting the initial amount of token
    - `receive()` proposal receives votes from user
    - `initialize()`
    - `withdraw()` get tokens back from a proposal 
    - ...

- Proposal.sol 
    - ... 

---

Jul 24, 2023

https://github.com/alexhkurz/blockchain-voting-mechanism/tree/346b2ec0030367c53b914d8b7a27342d9563c6ee

https://sepolia.etherscan.io/address/0xDe8890652A36bcFB6F2C90cbEC6d12aCfD57Ba5F#code

---