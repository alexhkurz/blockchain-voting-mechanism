import { task, types } from 'hardhat/config';

task('deploy', 'Deploys provided contract to specified network')
  .addParam('contract', 'The name of contract', undefined, types.string)
  .addOptionalParam('args', 'The constructor arguments', undefined, types.string)
  .setAction(async (taskArgs: { contract: string; args: string }, hre) => {
    await hre.run('compile');

    const CONTRACT = await hre.ethers.getContractFactory(taskArgs.contract);
    const args = taskArgs.args ? taskArgs.args.split(',') : [];
    const contract = await CONTRACT.deploy(...args);

    await contract.deployed();

    console.log('\nContract deployed to:', contract.address);
  });
