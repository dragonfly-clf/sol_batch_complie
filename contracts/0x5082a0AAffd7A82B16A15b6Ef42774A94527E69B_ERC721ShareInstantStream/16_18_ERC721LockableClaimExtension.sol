// SPDX-License-Identifier: AGPL-3.0

pragma solidity 0.8.9;

import "./02_18_Initializable.sol";
import "./01_18_Ownable.sol";
import "./11_18_ERC165Storage.sol";

import "./07_18_Address.sol";
import "./09_18_Counters.sol";
import "./03_18_ReentrancyGuard.sol";
import "./04_18_IERC20.sol";
import "./05_18_IERC721.sol";

import "./14_18_ERC721MultiTokenStream.sol";

interface IERC721LockableClaimExtension {
    function hasERC721LockableClaimExtension() external view returns (bool);

    function setClaimLockedUntil(uint64 newValue) external;
}

abstract contract ERC721LockableClaimExtension is
    IERC721LockableClaimExtension,
    Initializable,
    Ownable,
    ERC165Storage,
    ERC721MultiTokenStream
{
    // Claiming is only possible after this time (unix timestamp)
    uint64 public claimLockedUntil;

    /* INTERNAL */

    function __ERC721LockableClaimExtension_init(uint64 _claimLockedUntil)
        internal
        onlyInitializing
    {
        __ERC721LockableClaimExtension_init_unchained(_claimLockedUntil);
    }

    function __ERC721LockableClaimExtension_init_unchained(
        uint64 _claimLockedUntil
    ) internal onlyInitializing {
        claimLockedUntil = _claimLockedUntil;

        _registerInterface(type(IERC721LockableClaimExtension).interfaceId);
    }

    /* ADMIN */

    function setClaimLockedUntil(uint64 newValue) public onlyOwner {
        require(lockedUntilTimestamp < block.timestamp, "CONFIG_LOCKED");
        claimLockedUntil = newValue;
    }

    /* PUBLIC */

    function hasERC721LockableClaimExtension() external pure returns (bool) {
        return true;
    }

    /* INTERNAL */

    function _beforeClaim(
        uint256 ticketTokenId_,
        address claimToken_,
        address beneficiary_
    ) internal virtual override {
        ticketTokenId_;
        claimToken_;
        beneficiary_;

        require(claimLockedUntil < block.timestamp, "CLAIM_LOCKED");
    }
}