// SPDX-License-Identifier: MIT

pragma solidity 0.6.12;

contract Board {
    uint256 public proposalCount;
    uint256 public totalShares;

    address dev;
    bool devBridgeBurned;
    
    enum Vote {
        Null,
        Yes,
        No
    }
    
    struct Member {
        address delegateKey;
        uint256 shares;
        uint256 jailed;
    }
    
    struct Proposal {
        address applicant;
        address proposer;
        address sponsor;
        uint sharesRequested;
        uint256 paymentRequested;
        address paymentToken;
        uint256 startingPeriod;
        uint256 yesVotes;
        uint256 noVotes;
        bool[6] flags;
        string details;
        mapping(address => Vote) votesByMember;
    }
    
    mapping(address => bool) public tokenWhiteList;
    
    mapping(address => Member) public members;
    mapping(address => address) public memberAddressByDelegateKey;
    
    mapping(uint256 => Proposal) public proposals;
    
    uint256[] public proposalQueue;
    
    modifier onlyMember {
        require(members[msg.sender].shares > 0, "not a member");
        _;
    }
    
    modifier onlyDelegate {
        require(members[memberAddressByDelegateKey[msg.sender]].shares > 0, "not a delegate");
        _;
    }
    
    constructor(address firstMember) public {
        
    }
    
    
    
}