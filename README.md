# README

https://github.com/alexhkurz/blockchain-voting-mechanism 

Based on the set-up from a [course](https://github.com/alexhkurz/introduction-to-smart-contracts) at Chapman University Spring 2023.

### Installation

```
npm i 
forge install
```

### Compilation

```
npm run compile
```

### Deployment

The contracts available [here](https://sepolia.etherscan.io/address/0xDe8890652A36bcFB6F2C90cbEC6d12aCfD57Ba5F#code) were deployed as follows (at [this commit](https://github.com/alexhkurz/blockchain-voting-mechanism/tree/346b2ec0030367c53b914d8b7a27342d9563c6ee)).

```
npx hardhat --network sepolia deploy --contract Registry
npx hardhat --network sepolia verify 0xDe8890652A36bcFB6F2C90cbEC6d12aCfD57Ba5F
```
