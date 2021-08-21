// SPDX-License-Identifier: GPL-3.0

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

pragma solidity 0.8.3;

contract GatewayCryptoDao {
    uint256 public memberCount;
    uint256 public proposalCount;
    uint256 public proposalTimeWindow;
    mapping(address => bool) public isMember;
    mapping(uint256 => Proposal) public proposals;
    
    struct Proposal {
        address proposer;
        uint256 deadline;
        string details;
        address token;
        uint256 amount;
        address beneficiary;
        address member;
        bool kick;
        uint256 votesFor;
        uint256 votesAgainst;
        mapping(address => Vote) votes;
        bool executed;
    }
    
    struct Vote {
        bool didVote;
        bool voteFor;
    }
    
    function submitProposal(
        string calldata _details,
        address _token,
        uint256 _amount,
        address _beneficiary,
        address _member,
        bool _kick
        ) public {
        require(isMember[msg.sender], "Only member can submit proposal");
        proposalCount++;
        Proposal storage proposal = proposals[proposalCount];
        proposal.proposer = msg.sender;
        proposal.deadline = block.timestamp + proposalTimeWindow;
        proposal.details = _details;
        proposal.token = _token;
        proposal.amount = _amount;
        proposal.beneficiary = _beneficiary;
        proposal.member = _member;
        proposal.kick = _kick;
    }
    
    function vote(uint256 _proposalId, bool _voteFor) public {
        require(isMember[msg.sender], "Only member can vote");
        Proposal storage proposal = proposals[_proposalId];
        require(block.timestamp < proposal.deadline, "Vote period already expired");
        require(!proposal.votes[msg.sender].didVote, "Address already voted");
        if( _voteFor) {
            proposal.votesFor++;
        } else {
            proposal.votesAgainst++;
        }
        proposal.votes[msg.sender].didVote = true;
        proposal.votes[msg.sender].voteFor = _voteFor;
    }
    
    function executeVote(uint256 _proposalId) public {
        require(isMember[msg.sender], "Only member can execute vote");
        Proposal storage proposal = proposals[_proposalId];
        require(block.timestamp > proposal.deadline || proposal.votesFor + proposal.votesAgainst >= memberCount, "Vote period must expire or everyone must vote to execute vote");
        require(!proposal.executed, "Vote already executed");
        
        if(proposal.votesFor > proposal.votesAgainst && (proposal.votesFor + proposal.votesAgainst) * 10000 / memberCount >= quorum) {
            if(proposal.member != address(0))
        }
    }
    

    
}
