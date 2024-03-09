// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// You can also run a script with `npx hardhat run <script>`. If you do that, Hardhat
// will compile your contracts, add the Hardhat Runtime Environment's members to the
// global scope, and execute the script.
const hre = require("hardhat");
async function main() {
  // const TetherToken = await hre.ethers.getContractFactory("TetherToken");

  // const defi = await hre.ethers.deployContract("DEFI", [
  //   "0x14B47cD2cf750b9477EF7B17bBbE428986c80D61",
  // ]);

  const StakingContract = await hre.ethers.deployContract("StakingContract", [
    "0xEA8c43c0DfC41Faab0eAa2B7dF164468b1DCE600",
  ]);
  // Start deployment, returning a promise that resolves to a contract object

  console.log("Contract deployed to address:", StakingContract.target);
}



// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
