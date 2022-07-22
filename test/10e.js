
const { expect } = require("chai")

const expectFailure = async (fn, err) => {
  let failure
  try {
    await fn()
  } catch (e) {
    failure = e
  }
  if (!!failure !== true) console.log(`expected error: ${err}, ${failure}`)
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
    const notCollector = signers[2]

    const TenETHGiveawayFactory = await ethers.getContractFactory('TenETHGiveaway', artist)
    const TenEthGiveaway = await TenETHGiveawayFactory.deploy()
    await TenEthGiveaway.deployed()

    const stakeValue = ethers.utils.parseEther('10')
    const payableEth = { value: stakeValue }

    expect(await TenEthGiveaway.connect(artist).totalSupply()).to.equal(0)
    expect(await TenEthGiveaway.connect(artist).exists()).to.equal(false)

    await expectFailure(
      () => TenEthGiveaway.connect(collector).redeem(),
      'Token does not exist'
    )
    await expectFailure(
      () => TenEthGiveaway.connect(notCollector).mint(payableEth),
      'Ownable'
    )

    await TenEthGiveaway.connect(artist).mint(payableEth)


    expect(await TenEthGiveaway.connect(artist).totalSupply()).to.equal(1)
    expect(await TenEthGiveaway.connect(artist).exists()).to.equal(true)


    await expectFailure(
      () => TenEthGiveaway.connect(collector).redeem(),
      'Caller is not token owner'
    )

    await TenEthGiveaway.connect(artist).transferFrom(artist.address, collector.address, 0)

    await expectFailure(
      () => TenEthGiveaway.connect(artist).redeem(),
      'Caller is not token owner'
    )

    await expectFailure(
      () => TenEthGiveaway.connect(notCollector).redeem(),
      'Caller is not token owner'
    )

    const startingCollectorBalance = num(await collector.getBalance())
    await TenEthGiveaway.connect(collector).redeem()
    const endingCollectorBalance = num(await collector.getBalance())

    expect(endingCollectorBalance - startingCollectorBalance).to.be.closeTo(10, 0.001)
    expect(await TenEthGiveaway.connect(artist).totalSupply()).to.equal(0)
    expect(await TenEthGiveaway.connect(artist).exists()).to.equal(false)


    await expectFailure(
      () => TenEthGiveaway.connect(notCollector).setScript('malicious script'),
      'Ownable'
    )

    await expectFailure(
      () => TenEthGiveaway.connect(notCollector).setParams('wrong license', 'www.wrong.com'),
      'Ownable'
    )

    TenEthGiveaway.connect(artist).setScript('console.log("new script")')
    TenEthGiveaway.connect(artist).setParams('new license', 'www.new.com')

    expect(await TenEthGiveaway.connect(artist).script()).to.equal('console.log("new script")')
    expect(await TenEthGiveaway.connect(artist).license()).to.equal('new license')
    expect(await TenEthGiveaway.connect(artist).externalUrl()).to.equal('www.new.com')


  })
})
