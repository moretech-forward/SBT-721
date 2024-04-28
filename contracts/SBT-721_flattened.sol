
// File: contracts/ERC721/Owned.sol


pragma solidity >=0.8.0;

/// @notice Simple single owner authorization mixin.
/// @author Solmate (https://github.com/transmissions11/solmate/blob/main/src/auth/Owned.sol)
abstract contract Owned {
    /// @notice Emitted when ownership is transferred.
    /// @param user The address of the previous owner.
    /// @param newOwner The address of the new owner.
    event OwnershipTransferred(address indexed user, address indexed newOwner);

    /// @notice The address of the current owner.
    address public owner;

    /// @notice Ensures a function is called by the current owner.
    modifier onlyOwner() virtual {
        require(msg.sender == owner, "UNAUTHORIZED");
        _;
    }

    /// @dev Sets the initial owner of the contract to the deployer.
    /// @param _owner The address of the initial owner.
    constructor(address _owner) {
        owner = _owner;
        emit OwnershipTransferred(address(0), _owner);
    }

    /// @notice Transfers ownership of the contract to a new address, or relinquishes ownership if the zero address is passed.
    /// @dev Can only be called by the current owner.
    /// @param newOwner The address to transfer ownership to, or the zero address to relinquish ownership.
    function transferOwnership(address newOwner) external virtual onlyOwner {
        owner = newOwner;
        emit OwnershipTransferred(msg.sender, newOwner);
    }
}

// File: contracts/ERC721/ERC721/ERC721.sol


pragma solidity >=0.8.0;

/// @notice Modern, minimalist, and gas efficient ERC-721 implementation.
/// @author Solmate (https://github.com/transmissions11/solmate/blob/main/src/tokens/ERC721.sol)
abstract contract ERC721 {
    /*//////////////////////////////////////////////////////////////
                                 EVENTS
    //////////////////////////////////////////////////////////////*/

    /// @notice Logs the transfer of an NFT between two addresses.
    event Transfer(
        address indexed from,
        address indexed to,
        uint256 indexed id
    );

    /*//////////////////////////////////////////////////////////////
                         METADATA STORAGE/LOGIC
    //////////////////////////////////////////////////////////////*/

    /// @notice Name of the token collection.
    string public name;

    /// @notice Symbol of the token collection.
    string public symbol;

    /// @notice A private mapping of token IDs to their corresponding URIs.
    mapping(uint256 tokenId => string) private _tokenURIs;

    /// @notice Returns the URI for a given token.
    /// @param tokenId The token ID for which URI is being fetched.
    /// @return The full URI string pointing to the token metadata.
    function tokenURI(
        uint256 tokenId
    ) public view virtual returns (string memory) {
        string memory _tokenURI = _tokenURIs[tokenId];
        return _tokenURI;
    }

    /// @notice Internally sets the URI for a given token.
    /// @param tokenId The token ID for which URI is being set.
    /// @param _tokenURI The URI string to set as the token's metadata link.
    function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal {
        _tokenURIs[tokenId] = _tokenURI;
    }

    /*//////////////////////////////////////////////////////////////
                      ERC721 BALANCE/OWNER STORAGE
    //////////////////////////////////////////////////////////////*/

    /// @notice Mapping to track the owner of each token ID.
    mapping(uint256 => address) internal _ownerOf;

    /// @notice Mapping to track the balance of tokens owned by each address.
    mapping(address => uint256) internal _balanceOf;

    /// @notice Returns the owner of a specific token ID.
    /// @param id The token ID whose owner is being queried.
    /// @return owner The address of the owner.
    function ownerOf(uint256 id) public view virtual returns (address owner) {
        require((owner = _ownerOf[id]) != address(0), "NOT_MINTED");
    }

    /// @notice Returns the number of tokens held by a given address.
    /// @param owner The address to query the balance of.
    /// @return The number of tokens owned by the input address.
    function balanceOf(address owner) public view virtual returns (uint256) {
        require(owner != address(0), "ZERO_ADDRESS");

        return _balanceOf[owner];
    }

    /*//////////////////////////////////////////////////////////////
                               CONSTRUCTOR
    //////////////////////////////////////////////////////////////*/

    /// @param _name The name of the token.
    /// @param _symbol The symbol of the token.
    constructor(string memory _name, string memory _symbol) {
        name = _name;
        symbol = _symbol;
    }

    /*//////////////////////////////////////////////////////////////
                              ERC165 LOGIC
    //////////////////////////////////////////////////////////////*/

    /// @notice Returns true if the contract supports an interface with the given ID.
    /// @param interfaceId The byte4 identifier of the interface.
    /// @return True if the interface is supported, false otherwise.
    function supportsInterface(
        bytes4 interfaceId
    ) public view virtual returns (bool) {
        return
            interfaceId == 0x01ffc9a7 || // ERC165 Interface ID for ERC165
            interfaceId == 0x80ac58cd || // ERC165 Interface ID for ERC721
            interfaceId == 0x5b5e139f || // ERC165 Interface ID for ERC721Metadata
            interfaceId == 0x49064906; // ERC4906  Interface ID for ERC721URIStorage
    }

    /*//////////////////////////////////////////////////////////////
                        INTERNAL MINT/BURN LOGIC
    //////////////////////////////////////////////////////////////*/

    /// @notice Mints a token to a specified address.
    /// @param to The address that will receive the created tokens.
    /// @param id The token ID to mint.
    function _mint(address to, uint256 id) internal virtual {
        require(to != address(0), "INVALID_RECIPIENT");

        require(_ownerOf[id] == address(0), "ALREADY_MINTED");

        // Counter overflow is incredibly unrealistic.
        unchecked {
            _balanceOf[to]++;
        }

        _ownerOf[id] = to;

        emit Transfer(address(0), to, id);
    }

    /// @notice Burns a token to a specified id.
    /// @param id The token ID to burn.
    function _burn(uint256 id) internal virtual {
        address owner = _ownerOf[id];

        require(owner != address(0), "NOT_MINTED");

        // Ownership check above ensures no underflow.
        unchecked {
            _balanceOf[owner]--;
        }

        delete _ownerOf[id];
        delete _tokenURIs[id];

        emit Transfer(owner, address(0), id);
    }

    /*//////////////////////////////////////////////////////////////
                        INTERNAL SAFE MINT LOGIC
    //////////////////////////////////////////////////////////////*/

    /// @notice Safely mints a token to a specified address, checking if the address is a contract that can accept ERC721 tokens.
    /// @param to The address that will receive the created tokens.
    /// @param id The token ID to mint.
    function _safeMint(address to, uint256 id) internal virtual {
        _mint(to, id);

        require(
            to.code.length == 0 ||
                ERC721TokenReceiver(to).onERC721Received(
                    msg.sender,
                    address(0),
                    id,
                    ""
                ) ==
                ERC721TokenReceiver.onERC721Received.selector,
            "UNSAFE_RECIPIENT"
        );
    }
}

/// @notice A generic interface for a contract which properly accepts ERC721 tokens.
/// @author Solmate (https://github.com/transmissions11/solmate/blob/main/src/tokens/ERC721.sol)
abstract contract ERC721TokenReceiver {
    /// @notice Handles the receipt of an NFT.
    /// @return Returns the selector to confirm the interface and proper receipt.
    function onERC721Received(
        address,
        address,
        uint256,
        bytes calldata
    ) external virtual returns (bytes4) {
        return ERC721TokenReceiver.onERC721Received.selector;
    }
}

// File: contracts/ERC721/SBT.sol


pragma solidity ^0.8.23;



/// @title Soulbound ERC721 Token
/// @notice Implements non-transferable ERC721 tokens managed by an owner.
/// @dev Extends ERC721 for token functionality and Owned for ownership management.
contract Soulbound is ERC721, Owned {
    /// @dev Stores the next token ID to be minted.
    uint256 private _nextTokenId;

    /// @dev Initializes the ERC721 token with a name and symbol, and sets the contract deployer as the owner.
    /// @param _name Name of the ERC721 token.
    /// @param _symbol Symbol of the ERC721 token.
    constructor(
        string memory _name,
        string memory _symbol
    ) payable ERC721(_name, _symbol) Owned(msg.sender) {}

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
