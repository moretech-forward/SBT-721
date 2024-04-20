import { Soulbound } from "../typechain-types";

export async function mintNFT(sbt: Soulbound, owner: string, tokenURI: string) {
  try {
    if (!sbt || !owner || !owner) {
      throw new Error(
        "It is necessary to provide all necessary parameters: sbt, owner and owner.address"
      );
    }

    const tx = await sbt.safeMint(owner, tokenURI);
    const receipt = await tx.wait();

    console.log("Gas used for mint", receipt?.gasUsed);

    // console.log("The NFT has been successfully created:", transactionReceipt);
    return tx;
  } catch (error) {
    console.error("Error when creating an NFT:", error);
    throw error;
  }
}
