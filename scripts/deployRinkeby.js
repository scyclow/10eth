async function main() {
  const signers = await ethers.getSigners()

  const artist = signers[0]
  const collector = signers[1]

  const TenETHGiveawayFactory = await ethers.getContractFactory('TenETHGiveaway', artist)
  const TenEthGiveaway = await TenETHGiveawayFactory.deploy()
  await TenEthGiveaway.deployed()

  const stakeValue = ethers.utils.parseEther('0.5')
  const payableEth = { value: stakeValue }

  await TenEthGiveaway.connect(artist).mint(payableEth)

  console.log(`TenEthGiveaway:`, TenEthGiveaway.address)
  console.log(`Artist addr:`, artist.address)
}


main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });