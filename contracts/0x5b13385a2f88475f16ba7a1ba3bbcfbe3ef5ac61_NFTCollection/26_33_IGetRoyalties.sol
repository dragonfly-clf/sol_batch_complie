// SPDX-License-Identifier: UNLICENSED

pragma solidity >=0.6.0;

import "./07_33_IGetRoyalties.sol";

abstract contract $IGetRoyalties is IGetRoyalties {
    bytes32 public __hh_exposed_bytecode_marker = "hardhat-exposed";

    constructor() {}

    receive() external payable {}
}