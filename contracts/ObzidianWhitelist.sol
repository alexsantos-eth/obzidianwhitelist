// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract ObzidianWhitelist is Ownable {
    // EVENTS
    event MemberAdded(address member);
    event MemberRemoved(address member);

    // MEMBER DATA
    struct Member { // Struct
        bool active;
        address wallet;
        uint256 mintCount;
    }

    // STORE MEMBERS
    uint256 membersCount;
    mapping (address => Member) members;

    // GET ALL MEMBERS
    function getTotalMembers() public view returns(uint256) {
        return membersCount;
    }

    // GET MEMBER
    function getMember(address wallet) public  view returns(Member memory member) {
        return members[wallet];
    }

    // VERIFY A MEMBER
    function validateMember(address wallet) public view returns(bool) {
        return members[wallet].active;
    }

    // SAVE USERS
    function addMember(address wallet) public onlyOwner {
        require(!members[wallet].active, "This wallet already stored in the whitelist");
        membersCount++;
        members[wallet] = Member(true, wallet, 0);
        emit MemberAdded(wallet);
    }

    // MINT A MEMBER
    function updateMemberMint(address wallet, uint256 size) public onlyOwner {
        require(members[wallet].active, "This wallet is not stored in the whitelist");
        members[wallet].mintCount = size;
    }

    // DISABLE MEMBER
    function disableMember(address wallet) public onlyOwner {
        require(members[wallet].active, "This wallet is not stored in the whitelist");
        members[wallet].active = false;
        emit MemberRemoved(wallet);
    } 

    // ENABLE MEMBER
    function enableMember(address wallet) public onlyOwner {
        require(!members[wallet].active, "This wallet is not disabled in the whitelist");
        members[wallet].active = true;
        emit MemberAdded(wallet);
    } 
}