// SPDX-License-Identifier: MIT OR Apache-2.0

pragma solidity ^0.8.12;

import "./9_27_ERC165Upgradeable.sol";

import "./16_27_IGetFees.sol";
import "./17_27_IGetRoyalties.sol";
import "./18_27_IRoyaltyInfo.sol";
import "./19_27_ITokenCreator.sol";

import "./26_27_Constants.sol";

/**
 * @title Defines various royalty APIs for broad marketplace support.
 * @author batu-inal & HardlyDifficult
 */
abstract contract CollectionRoyalties is IGetRoyalties, IGetFees, IRoyaltyInfo, ITokenCreator, ERC165Upgradeable {
  /**
   * @inheritdoc IGetFees
   */
  function getFeeRecipients(uint256 tokenId) external view returns (address payable[] memory recipients) {
    recipients = new address payable[](1);
    recipients[0] = getTokenCreatorPaymentAddress(tokenId);
  }

  /**
   * @inheritdoc IGetFees
   * @dev The tokenId param is ignored since all NFTs return the same value.
   */
  function getFeeBps(uint256 /* tokenId */) external pure returns (uint256[] memory royaltiesInBasisPoints) {
    royaltiesInBasisPoints = new uint256[](1);
    royaltiesInBasisPoints[0] = ROYALTY_IN_BASIS_POINTS;
  }

  /**
   * @inheritdoc IGetRoyalties
   */
  function getRoyalties(
    uint256 tokenId
  ) external view returns (address payable[] memory recipients, uint256[] memory royaltiesInBasisPoints) {
    recipients = new address payable[](1);
    recipients[0] = getTokenCreatorPaymentAddress(tokenId);
    royaltiesInBasisPoints = new uint256[](1);
    royaltiesInBasisPoints[0] = ROYALTY_IN_BASIS_POINTS;
  }

  /**
   * @notice The address to pay the creator proceeds/royalties for the collection.
   * @param tokenId The ID of the NFT to get the creator payment address for.
   * @return creatorPaymentAddress The address to which royalties should be paid.
   */
  function getTokenCreatorPaymentAddress(
    uint256 tokenId
  ) public view virtual returns (address payable creatorPaymentAddress);

  /**
   * @inheritdoc IRoyaltyInfo
   */
  function royaltyInfo(
    uint256 tokenId,
    uint256 salePrice
  ) external view returns (address receiver, uint256 royaltyAmount) {
    receiver = getTokenCreatorPaymentAddress(tokenId);
    unchecked {
      royaltyAmount = salePrice / ROYALTY_RATIO;
    }
  }

  /**
   * @inheritdoc IERC165Upgradeable
   * @dev Checks the supported royalty interfaces.
   */
  function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool interfaceSupported) {
    interfaceSupported = (interfaceId == type(IRoyaltyInfo).interfaceId ||
      interfaceId == type(ITokenCreator).interfaceId ||
      interfaceId == type(IGetRoyalties).interfaceId ||
      interfaceId == type(IGetFees).interfaceId ||
      super.supportsInterface(interfaceId));
  }
}
