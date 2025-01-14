// SPDX-License-Identifier: reup.cash
pragma solidity ^0.8.17;

import "./09_31_IMinter.sol";
import "./30_31_Roles.sol";

abstract contract Minter is IMinter
{
    bytes32 private constant MinterRole = keccak256("ROLE:Minter");

    function getMinterOwner() internal virtual view returns (address);

    function isMinter(address user)
        public
        view
        returns (bool)
    {
        return Roles.hasRole(MinterRole, user);
    }

    modifier onlyMinter()
    {
        if (!isMinter(msg.sender)) { revert NotMinter(); }
        _;
    }

    function setMinter(address user, bool canMint)
        public
    {
        if (msg.sender != getMinterOwner()) { revert NotMinterOwner(); }
        emit SetMinter(user, canMint);
        Roles.setRole(MinterRole, user, canMint);
    }
}