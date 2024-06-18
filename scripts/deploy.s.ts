import { ethers } from "hardhat";

// npx hardhat run scripts/deploy.s.ts --network localhost

async function main() {
  const SBT = await ethers.getContractFactory("Soulbound");
  const sbt = await SBT.deploy("My token", "MySBT");

  await sbt.safeMint(
    "0x4eb6EBcfA62792A01E5005c453F39D63493a79B8",
    "https://ipfs.io/ipfs/QmaNMk641puZy1uth85UCM4MZiXB9qUyuverkBo5bPu35n"
  );

  await sbt.safeMint("0x4eb6EBcfA62792A01E5005c453F39D63493a79B8", "");

  await sbt.safeMint(
    "0xf39fd6e51aad88f6f4ce6ab8827279cfffb92266",
    "https://ipfs.io/ipfs/"
  );

  console.log(`Soulbound deployed to ${await sbt.getAddress()}`);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
