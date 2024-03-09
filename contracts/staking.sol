//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract StakingContract is Ownable {
    using SafeERC20 for IERC20;
    
    IERC20 public defiToken;
    uint256 public constant rewardPerStakePerDay = 1e18; //1 * 10**18; // 1 DEFI per 1000 DEFI staked per day
    uint256 public constant blocksPerDay = 7200;             //24 * 60 * 60 / 6; // Ethereum block time is approximately 6 seconds
    
    struct Stake {
        uint256 amount;
        uint256 startTime;
        uint256 stakedblocknumber;
    }
    
    mapping(address => Stake) public stakes;
    
    event Staked(address indexed user, uint256 amount);
    event Withdrawn(address indexed user, uint256 amount);
    
    constructor(address _defiToken)Ownable(msg.sender) {
        defiToken = IERC20(_defiToken);
    }
    
    function stake(uint256 amount) external {
        require(amount > 0, "Amount must be greater than 0");
        require(defiToken.balanceOf(msg.sender) >= amount, "Insufficient DEFI balance");
        require(stakes[msg.sender].amount == 0, "User has already staked");
        
        Stake memory newStake;
        newStake.amount = amount;
        newStake.startTime = block.timestamp;
        newStake.stakedblocknumber = block.number;
        
        stakes[msg.sender] = newStake;
        
        defiToken.safeTransferFrom(msg.sender, address(this), amount);
        
        emit Staked(msg.sender, amount);
    }
    
    function withdraw() external {
        Stake storage userStake = stakes[msg.sender];
        require(userStake.amount > 0, "No staked amount");

        uint256 reward = calculateReward(userStake);
        uint256 totalPayout = userStake.amount + reward;

        delete stakes[msg.sender];

        defiToken.safeTransfer(msg.sender, totalPayout);

        emit Withdrawn(msg.sender, totalPayout);
    }
    
    function calculateReward(Stake memory userStake) internal view returns (uint256) {
        uint256 elapsedTime = block.timestamp - userStake.startTime;
    
        uint256 reward = (elapsedTime/blocksPerDay)*rewardPerStakePerDay;
        uint256 reward2=reward+1000;
        uint256 reward3= (block.number - userStake.stakedblocknumber) * 1000 + 1000;
        uint256 totalreward = reward+reward2+reward3;
       
        return totalreward;
    }

    function getStakerDetails() public view returns(Stake memory ) {
        return stakes[msg.sender];
    }

    function getrewards() public view returns(uint256 ) {
         Stake memory userStake = stakes[msg.sender];
        return calculateReward(userStake);
    }
}