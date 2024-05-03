// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import {ERC721} from "./ERC721/ERC721.sol";
import {Owned} from "./Owned.sol";

/// @title Soulbound ERC721 Token
/// @notice Implements non-transferable ERC721 tokens managed by an owner.
/// @dev Extends ERC721 for token functionality and Owned for ownership management.
contract Soulbound is ERC721, Owned {
    /// @notice Auxiliary variable for frontend
    address public immutable myAddr;

    /// @dev Stores the next token ID to be minted.
    uint256 private _nextTokenId;

    /// @dev Initializes the ERC721 token with a name and symbol, and sets the contract deployer as the owner.
    /// @param _name Name of the ERC721 token.
    /// @param _symbol Symbol of the ERC721 token.
    constructor(
        string memory _name,
        string memory _symbol
    ) payable ERC721(_name, _symbol) Owned(msg.sender) {
        myAddr = address(this);
    }

    /// @notice Mints a new token to a specified address with a provided URI.
    /// @dev Only callable by the owner.
    /// @param to The address to receive the minted token.
    /// @param uri The metadata URI to associate with the minted token.
    function safeMint(address to, string memory uri) external onlyOwner {
        uint256 tokenId = _nextTokenId++;
        _safeMint(to, tokenId);
        _setTokenURI(tokenId, uri);
    }

    /// @notice Mints multiple tokens to the specified addresses with corresponding URIs in a single transaction.
    /// @dev The lengths of the `to` and `uris` arrays must match; only callable by the owner.
    /// @param to An array of addresses that will each receive a minted token.
    /// @param uris An array of metadata URIs corresponding to each token to be minted.
    function safeBatchMint(
        address[] memory to,
        string[] memory uris
    ) external onlyOwner {
        uint256 len = to.length;
        require(len == uris.length, "length mismatch");

        for (uint i = 0; i < len; ++i) {
            uint256 tokenId = _nextTokenId++;
            _safeMint(to[i], tokenId);
            _setTokenURI(tokenId, uris[i]);
        }
    }

    /// @notice Burns a token to a specified id.
    /// @dev Only callable by the owner.
    /// @param id The token ID to burn.
    function burn(uint256 id) external onlyOwner {
        _burn(id);
    }
}
