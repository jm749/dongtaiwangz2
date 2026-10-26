const hre = require("hardhat");

async function main() {
  console.log("deploy voting contract......");

  // 获取合约工厂
  const Voting = await hre.ethers.getContractFactory("Voting");
  // 部署合约
  const voting = await Voting.deploy();
  // 等待上链确认
  await voting.waitForDeployment();

  const address = await voting.getAddress();
  console.log(`Voting contract deployed to: ${address}`);

  // 部署完成后，自动添加初始候选人（只有admin可以调用）
  console.log("Adding initial candidates....");
  await voting.addCandidate("Alice");
  await voting.addCandidate("Bob");
  await voting.addCandidate("Charlie");
  console.log("Initial candidates added: Alice, Bob, Charlie");
  console.log("Deployment complete!");

  // 打印合约地址，复制给前端使用
  console.log("========================================");
  console.log("Contract Address (copy this for frontend):");
  console.log(address);
  console.log("========================================");
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});