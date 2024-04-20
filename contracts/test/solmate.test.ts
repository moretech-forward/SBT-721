import { loadFixture } from "@nomicfoundation/hardhat-toolbox/network-helpers";
import { expect } from "chai";
import hre from "hardhat";
import { mintNFT } from "./mint";

describe("SBT Solmate", function () {
  async function deployFixture() {
    const [owner, otherAccount] = await hre.ethers.getSigners();

    const SBT = await hre.ethers.getContractFactory("Soulbound");
    const sbt = await SBT.deploy("Soulbound Token", "SBT");
    const receipt = await sbt.deploymentTransaction()?.wait();
    console.log("Gas used for deploy", receipt?.gasUsed);

    return { sbt, owner, otherAccount };
  }

  it("Right name and symbol", async function () {
    const { sbt } = await loadFixture(deployFixture);

    expect(await sbt.name()).to.equal("Soulbound Token");
    expect(await sbt.symbol()).to.equal("SBT");
  });

  it("Right owner", async function () {
    const { sbt, owner } = await loadFixture(deployFixture);

    expect(await sbt.owner()).to.equal(owner.address);
  });

  it("Mint", async function () {
    const { sbt, owner } = await loadFixture(deployFixture);
    await expect(mintNFT(sbt, owner.address, "123")).to.emit(sbt, "Transfer");
    expect(await sbt.balanceOf(owner)).to.equal(1n);
    expect(await sbt.tokenURI(0)).to.equal("123");
    expect(await sbt.ownerOf(0)).to.equal(owner);
  });

  it("Batch mint", async function () {
    const { sbt, owner } = await loadFixture(deployFixture);
    await sbt.safeBatchMint(
      [owner, owner, owner, owner],
      ["123", "132", "123", "qwe"]
    );
  });
});
