const hre = require("hardhat");

async function main() {
  const VotingTokenContract = await hre.ethers.getContractFactory("Topic");
  const votingToken = await VotingTokenContract.deploy("topicTestName1","topicTestDescription1");
  
  await votingToken.deployed();

  console.log("deployed successful", votingToken.address);

  main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
  });
}
