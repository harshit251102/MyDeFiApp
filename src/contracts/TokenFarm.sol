pragma solidity ^0.5.0;
import "./DaiToken.sol";
import "./DappToken.sol";

contract TokenFarm {
    string public name = "Dapp Token Farm";
    DappToken public dappToken;
    DaiToken public daiToken;
    address public owner;

    address[] public stakers;
    mapping(address => uint) public stakingBalance;
    mapping(address => bool) public hasStaked;
    mapping(address => bool) public isStaking;

    constructor(DappToken _dappToken, DaiToken _daiToken) public {
        dappToken = _dappToken;
        daiToken = _daiToken;
        owner = msg.sender;
    }

    // Staking Tokens (Deposit)
    function stakeTokens(uint _amount) public {
        // Require amount greater than 0
        require(_amount > 0, "amount cannot be 0");

        // Transfer Mock Dai tokens to this contract for staking
        daiToken.transferFrom(msg.sender, address(this), _amount);

        // Update Staking Balance
        stakingBalance[msg.sender] += _amount;

        // Add user to stakers array *only* if they haven't staked already
        if(!hasStaked[msg.sender]) {
            isStaking[msg.sender] = true;
            stakers.push(msg.sender);
        }
    }

    // Unstaking Tokens (Withdraw)
    function unstakeTokens() public {
        //Fetch staking balance
        uint balance = stakingBalance[msg.sender];
        require(balance > 0, "staking balance cannot be 0");

        //Transfer Mock Dai tokens to this contract for staking
        daiToken.transfer(msg.sender, balance);

        //Reset Stake Balance
        stakingBalance[msg.sender] = 0;

        //Update Staking Status
        isStaking[msg.sender] = false;
    }

    //Issuing Tokens
    function issueTokens() public {
        // Only owner can call this function
        require(msg.sender == owner, "caller must be the owner");

        // Issue tokens to all stakers
        for (uint i=0; i<stakers.length; i++) {
            address recipient = stakers[i];
            uint balance = stakingBalance[recipient];
            if (balance > 0) {
                dappToken.transfer(recipient, balance);
            }
        }
    }
}