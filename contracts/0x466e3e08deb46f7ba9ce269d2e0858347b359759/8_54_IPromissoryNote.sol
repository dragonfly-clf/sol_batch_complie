// SPDX-License-Identifier: MIT

pragma solidity 0.8.18;

import "./9_54_IERC721Enumerable.sol";

import "./10_54_INFTWithDescriptor.sol";

interface IPromissoryNote is INFTWithDescriptor, IERC721Enumerable {
    // ============== Token Operations ==============

    function mint(address to, uint256 loanId) external returns (uint256);

    function burn(uint256 tokenId) external;

    // ============== Initializer ==============

    function initialize(address loanCore) external;
}
