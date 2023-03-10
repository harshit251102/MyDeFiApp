const TokenFarm = artifacts.require("TokenFarm");
const DaiToken = artifacts.require("DaiToken");
const DappToken = artifacts.require("DappToken");

require('chai')
    .use(require('chai-as-promised'))
    .should()

function tokens(n) {
    return web3.utils.toWei(n, 'ether');
}

contract('TokenFarm', ([owner,investor]) => {
    let daiToken, dappToken, tokenFarm;

    before(async () => {
        //Load Contracts
        daiToken = await DaiToken.new()
        dappToken = await DappToken.new()
        tokenFarm = await TokenFarm.new(dappToken.address, daiToken.address)

        //Transfer all Dapp tokens to farm (1 million)
        await dappToken.transfer(tokenFarm.address,tokens('1000000'))

        //Send tokens to investor
        await daiToken.transfer(investor,tokens('200'), {from: owner})
    })

    describe('Mock DAI deployment', async () => {
        it('has a name', async () => {
            let daiToken = await DaiToken.new()
            const name = await daiToken.name()
            assert.equal(name, 'Mock DAI Token')
        })
    })

    describe('Dapp Token Deployment', async () => {
        it('has a name', async() => {
            const name = await dappToken.name()
            assert.equal(name, 'DApp Token')
        })
    })

    describe('Token Farm Deployment', async () => {
        it('has a name', async() => {
            const name = await tokenFarm.name()
            assert.equal(name, 'Dapp Token Farm')
        })

        it('contract has tokens', async() => {
            let balance = await dappToken.balanceOf(tokenFarm.address)
            assert.equal(balance.toString(), tokens('1000000'))
        })
    })

    describe('Farming tokens', async() => {
        it('rewards investors for staking mDai tokens', async() => {
            let result

            //check investor balance before staking
            result = await daiToken.balanceOf(investor)
            assert.equal(result.toSting(),tokens('100'), 'investor Mock DAI wallet balance correct before staking')

        })
    })
})