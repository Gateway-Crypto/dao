// SPDX-License-Identifier: MIT

pragma solidity 0.6.12;

import "./CommunityToken.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Community {
    
    uint256 public proposalCount;
    CommunityToken public communityToken;
    uint256 public debatingPeriod;
    uint256 public votingPeriod;
    
    enum Vote {
        Null,
        Yes,
        No
    }
    
    struct Proposal {
        address proposer;
        string description;
        uint256 startTime; // Timestamp when voting can start
        mapping(address => Vote) votesByMember;
    }
    
    mapping(uint256 => Proposal) public proposals;
    mapping(address => bool) public members;
    
    modifier onlyShareholder {
        require(communityToken.balanceOf(msg.sender) > 0);
        _;
    }
    
    modifier onlyMember {
        require(members[msg.sender]);
        _;
    }
    
    constructor(
        CommunityToken _communityToken,
        uint256 _debatingPeriodInHours,
        uint256 _votingPeriodInHours) 
        public {
        communityToken = _communityToken;
        debatingPeriod = _debatingPeriodInHours * 1 hours;
        votingPeriod = _votingPeriodInHours * 1 hours;
    }
    
    function submitProposal(string memory _description) public onlyShareholder {
        proposals[proposalCount] = Proposal(msg.sender, _description, now + debatingPeriod);
        proposalCount++;
    }
    
    function vote(uint256 proposalIndex, uint8 uintVote) public onlyShareholder onlyMember {
        
    }
}