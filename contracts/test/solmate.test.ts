import { loadFixture } from "@nomicfoundation/hardhat-toolbox/network-helpers";
import { expect } from "chai";
import hre from "hardhat";

describe("SBT Solmate", function () {
  async function deployFixture() {
    const [owner, otherAccount, otherAccount2] = await hre.ethers.getSigners();

    const SBT = await hre.ethers.getContractFactory("Soulbound");
    const sbt = await SBT.deploy("Soulbound Token", "SBT");
    const receipt = await sbt.deploymentTransaction()?.wait();
    console.log("Gas used for deploy", receipt?.gasUsed);

    return { sbt, owner, otherAccount, otherAccount2 };
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
    await expect(sbt.safeMint(owner, "123")).to.emit(sbt, "Transfer");
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

  it("owner burns otherAccount's NFT", async function () {
    const { sbt, otherAccount } = await loadFixture(deployFixture);

    await expect(sbt.safeMint(otherAccount, "123")).to.emit(sbt, "Transfer");
    expect(await sbt.balanceOf(otherAccount)).to.equal(1n);
    expect(await sbt.ownerOf(0)).to.equal(otherAccount);

    await expect(sbt.burn(0)).to.emit(sbt, "Transfer");
    expect(await sbt.balanceOf(otherAccount)).to.equal(0n);
  });

  it("otherAccount burns otherAccount's NFT", async function () {
    const { sbt, otherAccount } = await loadFixture(deployFixture);

    await expect(sbt.safeMint(otherAccount, "123")).to.emit(sbt, "Transfer");
    expect(await sbt.balanceOf(otherAccount)).to.equal(1n);
    expect(await sbt.ownerOf(0)).to.equal(otherAccount);
    await expect(sbt.connect(otherAccount).burn(0)).to.be.revertedWith(
      "UNAUTHORIZED"
    );
  });

  it("otherAccount burns owner's NFT", async function () {
    const { sbt, owner, otherAccount } = await loadFixture(deployFixture);

    await expect(sbt.safeMint(owner, "123")).to.emit(sbt, "Transfer");
    expect(await sbt.balanceOf(owner)).to.equal(1n);
    expect(await sbt.ownerOf(0)).to.equal(owner);
    await expect(sbt.connect(otherAccount).burn(0)).to.be.revertedWith(
      "UNAUTHORIZED"
    );
  });
});
