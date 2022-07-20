
const { expect } = require("chai")

const expectFailure = async (fn, err) => {
  let failure
  try {
    await fn()
  } catch (e) {
    failure = e
  }
  expect(!!failure).to.equal(true)
  expect(failure?.message).to.include(err)
}

const num = n => Number(ethers.utils.formatEther(n))

describe('10E', () => {
  it('should work', async () => {
    const signers = await ethers.getSigners()

    const artist = signers[0]
    const collector = signers[1]

    const TenETHFactory = await ethers.getContractFactory('TenETH', artist)
    const TenEth = await TenETHFactory.deploy()
    await TenEth.deployed()

    const stakeValue = ethers.utils.parseEther('.10')
    const payableEth = { value: stakeValue }

    expect(await TenEth.connect(artist).totalSupply()).to.equal(0)
    expect(await TenEth.connect(artist).exists()).to.equal(false)
    // console.log('Pre fund',
    //   (await TenEth.connect(artist).tokenURI(0)).replace('data:application/json;base64,', '')
    // )

    await TenEth.connect(artist).mint(payableEth)

    // console.log('Post fund',
    //   (await TenEth.connect(artist).tokenURI(0)).replace('data:application/json;base64,', '')
    // )
    expect(await TenEth.connect(artist).totalSupply()).to.equal(1)
    expect(await TenEth.connect(artist).exists()).to.equal(true)

    await expectFailure(
      () => TenEth.connect(collector).redeem(),
      'Caller is not token owner'
    )

    await TenEth.connect(artist).transferFrom(artist.address, collector.address, 0)

    await expectFailure(
      () => TenEth.connect(artist).redeem(),
      'Caller is not token owner'
    )

    const startingCollectorBalance = num(await collector.getBalance())
    await TenEth.connect(collector).redeem()
    const endingCollectorBalance = num(await collector.getBalance())

    expect(endingCollectorBalance - startingCollectorBalance).to.be.closeTo(10, 0.001)
    expect(await TenEth.connect(artist).totalSupply()).to.equal(0)
    expect(await TenEth.connect(artist).exists()).to.equal(false)

  })
})
