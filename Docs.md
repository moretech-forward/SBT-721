# Docs

## Contract

The contract is a minimalistic and gas-efficient version of ERC721 with the `transfer`, `approve`, etc. features stripped out to further reduce the size of the contract for deployment.

But the main interface of ERC721 for NFT operation is preserved, therefore they are displayed in the user's wallet (MetaMask, TrustWallet) and defined by NFT aggregators (OpenSea)

### ERC721

Each person gets an NFT with its own `id`, that is, one `id` can belong to **only** one person. Each `id` can have its own metadata. Autoincrement of `id` works.

## Functions

### `constructor`

Initializes the ERC721 token with a name and symbol, and sets the contract deployer as the `owner`.

- `_name` Name of the ERC721 token collection.
- `_symbol` Symbol of the ERC721 token collection.

### `safeMint`

Mints a new token to a specified address with a provided URI. Only callable by the `owner`.

- `to` The address to receive the minted token.
- `uri` The metadata URI to associate with the minted token.

`uri` - link to the json file example at the end of the documentation

### `safeBatchMint`

Mints multiple tokens to the specified addresses with corresponding URIs in a single transaction. The lengths of the `to` and `uris` arrays must match; only callable by the `owner`.

- `to` An array of addresses that will each receive a minted token.
- `uris` An array of metadata URIs corresponding to each token to be minted.

### `burn`

Burns a token to a specified id.
Only callable by the `owner`.

- `id` The token ID to burn.

### `transferOwnership`

Transfers ownership of the contract to a new address, or relinquishes ownership if the zero address is passed.
Can only be called by the current `owner`.

- `newOwner` The address to transfer ownership to, or the zero address to relinquish ownership.

## Metadata example

```json
{
  "name": "NFT name, displayed in wallets.",
  "description": "Description, displayed in wallets",
  "image": "Link to the picture, the picture is displayed in the wallets",

  "strength": "The rest goes extra and is optional",
  "attributes": [
    //  is accurately displayed in Trust Wallet
    { "trait_type": "Team", "value": "zkToken" },
    { "trait_type": "Reward", "value": "Finalist" }
  ]
}
```
