async function main() {
  const signers = await ethers.getSigners()

  const artist = signers[0]
  const collector = signers[1]

  const TenETHFactory = await ethers.getContractFactory('TenETH', artist)
  const TenEth = await TenETHFactory.deploy()
  await TenEth.deployed()

  const stakeValue = ethers.utils.parseEther('0.001')
  const payableEth = { value: stakeValue }

  await TenEth.connect(artist).mint(payableEth)

  console.log(`TenEth:`, TenEth.address)
  console.log(`Artist addr:`, artist.address)
}


main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });