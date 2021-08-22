const { expect } = require("chai");
const { ethers } = require("hardhat");
const { time } = require("@openzeppelin/test-helpers");

describe("GatewayCryptoDao", function() {

	let dao;
	let token1;
	let token2;
	let accounts;
	let members = [];
	const PROPOSAL_TIME_WINDOW = 60*60*24*3;
	const QUORUM = 5000;
	const INITIAL_MEMBER_COUNT = 5;

	beforeEach(async function () {
		accounts = await ethers.getSigners();
		for(let i=0; i<INITIAL_MEMBER_COUNT; i++) {
			members.push(accounts[i].address);
		}
		const GatewayCryptoDao = await ethers.getContractFactory("GatewayCryptoDao");
		dao = await GatewayCryptoDao.deploy(QUORUM, PROPOSAL_TIME_WINDOW, members);
		await dao.deployed();
		const ERC20 = await ethers.getContractFactory("CommunityToken");
		token1 = await ERC20.deploy();
		await token1.deployed();
		await token1.mint(dao.address, ethers.utils.parseEther("100"));
		token2 = await ERC20.deploy();
		await token2.deployed();
		await token2.mint(dao.address, ethers.utils.parseEther("200"));
	});

	it("constructor()", async function() {
		let quorumFromContract = await dao.quorum();
		expect(quorumFromContract).to.equal(QUORUM);
		let proposalTimeWindowFromContract = await dao.proposalTimeWindow();
		expect(proposalTimeWindowFromContract).to.equal(PROPOSAL_TIME_WINDOW);
		let memberCountFromContract = await dao.memberCount();
		expect(memberCountFromContract).to.equal(INITIAL_MEMBER_COUNT);
		expect(await dao.isMember(accounts[0].address), "Account 0 should be member").to.be.true;
		expect(await dao.isMember(accounts[1].address), "Account 1 should be member").to.be.true;
		expect(await dao.isMember(accounts[2].address), "Account 2 should be member").to.be.true;
		expect(await dao.isMember(accounts[3].address), "Account 3 should be member").to.be.true;
		expect(await dao.isMember(accounts[4].address), "Account 4 should be member").to.be.true;
		expect(await dao.isMember(accounts[5].address), "Account 5 should NOT be member").to.be.false;
	});

	it("submitProposal()", async function() {
		details = "Test proposal 1";
		amount = ethers.utils.parseEther("10");
		beneficiary = accounts[5].address;
		await dao.connect(accounts[1]).submitProposal(details, token1.address, amount, beneficiary, ethers.constants.AddressZero, false);
	});
});
