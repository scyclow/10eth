
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

const b64Clean = raw => raw.replace(/data.*,/, '')
const b64Decode = raw => Buffer.from(clean(raw)).toString()
const getJsonURI = rawURI => JSON.parse(b64Decode(rawURI))



const num = n => Number(ethers.utils.formatEther(n))

describe('10E', () => {
  it('should work', async () => {
    const signers = await ethers.getSigners()

    const artist = signers[0]
    const collector = signers[1]

    const TenETHGiveawayFactory = await ethers.getContractFactory('TenETHGiveaway', artist)
    const TenEthGiveaway = await TenETHGiveawayFactory.deploy()
    await TenEthGiveaway.deployed()

    const stakeValue = ethers.utils.parseEther('10')
    const payableEth = { value: stakeValue }

    expect(await TenEthGiveaway.connect(artist).totalSupply()).to.equal(0)
    expect(await TenEthGiveaway.connect(artist).exists()).to.equal(false)
    // console.log('Pre fund',
    //   (await TenEthGiveaway.connect(artist).tokenURI(0)).replace('data:application/json;base64,', '')
    // )

    await TenEthGiveaway.connect(artist).mint(payableEth)

    // console.log('Post fund',
    //   (await TenEthGiveaway.connect(artist).tokenURI(0)).replace('data:application/json;base64,', '')
    // )
    expect(await TenEthGiveaway.connect(artist).totalSupply()).to.equal(1)
    expect(await TenEthGiveaway.connect(artist).exists()).to.equal(true)

    console.log(getJsonURI(await TenEthGiveaway.connect(artist).tokenURI(0)))

    await expectFailure(
      () => TenEthGiveaway.connect(collector).redeem(),
      'Caller is not token owner'
    )

    await TenEthGiveaway.connect(artist).transferFrom(artist.address, collector.address, 0)

    await expectFailure(
      () => TenEthGiveaway.connect(artist).redeem(),
      'Caller is not token owner'
    )

    const startingCollectorBalance = num(await collector.getBalance())
    await TenEthGiveaway.connect(collector).redeem()
    const endingCollectorBalance = num(await collector.getBalance())

    expect(endingCollectorBalance - startingCollectorBalance).to.be.closeTo(10, 0.001)
    expect(await TenEthGiveaway.connect(artist).totalSupply()).to.equal(0)
    expect(await TenEthGiveaway.connect(artist).exists()).to.equal(false)


  })
})
