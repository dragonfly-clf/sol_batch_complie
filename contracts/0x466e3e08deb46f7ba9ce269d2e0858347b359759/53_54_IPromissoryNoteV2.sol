// SPDX-License-Identifier: MIT

pragma solidity ^0.8.11;

import "./9_54_IERC721Enumerable.sol";

interface IPromissoryNoteV2 is IERC721Enumerable {
    // ============== Token Operations ==============

    function mint(address to, uint256 loanId) external returns (uint256);

    function burn(uint256 tokenId) external;

    function setPaused(bool paused) external;

    // ============== Initializer ==============

    function initialize(address loanCore) external;
}