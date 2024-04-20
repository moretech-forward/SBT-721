// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {ERC721} from "./ERC721/ERC721.sol";
import {Owned} from "./Owned.sol";

contract Soulbound is ERC721, Owned {
    uint256 private _nextTokenId;

    constructor(
        string memory _name,
        string memory _symbol
    ) ERC721(_name, _symbol) Owned(msg.sender) {}

    function safeMint(address to, string memory uri) external onlyOwner {
        uint256 tokenId = _nextTokenId++;
        _safeMint(to, tokenId);
        _setTokenURI(tokenId, uri);
    }

    function safeBatchMint(
        address[] memory to,
        string[] memory uris
    ) external onlyOwner {
        require(to.length == uris.length, "length mismatch");

        for (uint i = 0; i < to.length; i++) {
            uint256 tokenId = _nextTokenId++;
            _safeMint(to[i], tokenId);
            _setTokenURI(tokenId, uris[i]);
        }
    }
}
