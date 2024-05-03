import { ethers } from "hardhat";

async function main() {
  const SBT = await ethers.getContractFactory("Soulbound");
  const sbt = await SBT.deploy("Soulbound Token", "SBT");

  await sbt.safeMint(
    "0x4eb6EBcfA62792A01E5005c453F39D63493a79B8",
    "https://ipfs.io/ipfs/QmaNMk641puZy1uth85UCM4MZiXB9qUyuverkBo5bPu35n"
  );

  console.log(`Soulbound deployed to ${await sbt.getAddress()}`);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
