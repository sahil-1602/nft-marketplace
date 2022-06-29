// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

    /*

    Building out the minting funtion:
        a. nft point to an address
        b. keep track of the token ids
        c. keep track of token owner address to token ids
        d. keep track of how many tokens an owner address has
        e. create an event that emits a tranfer log - contract address,
            where it is being minted to, the id

    */


contract ERC721 {

    event Transfer(
        address indexed from,
        address indexed to,
        uint256 indexed tokenId);

    // Mapping from token id to the owner
    mapping(uint256 => address) private _tokenOwner;

    // Mapping from owner to number of owned tokens
    mapping(address => uint256) private _OwnedTokensCount;

    function balanceOf(address _owner) public view returns(uint256) {
        require(_owner != address(0), 'ERC721: Address cannot be zero');
        return _OwnedTokensCount[_owner];
    }

    function ownerOf(uint256 _tokenId) external view returns (address) {
        address owner = _tokenOwner[_tokenId];
        require(owner != address(0), 'ERC721: Owner does not exist');
        return owner;
    }

    function _exists(uint256 tokenId) internal view returns(bool) {
        // setting the address of nft owner to check the mapping
        // of the address from tokenOwner at the tokenId
        address owner = _tokenOwner[tokenId];
        // return truthiness the address is not zero
        return owner != address(0);
    }

    function _mint(address to, uint256 tokenId) internal {
        // requires that the address isn't zero
        require(to != address(0), 'ERC721: minting to the zero address');
        // requires that the token does not already exists
        require(!_exists(tokenId), 'ERC721: token already minted');
        // we are adding a new address with a token id for minting
        _tokenOwner[tokenId] = to;
        // keeping track of each address that is minting and adding one
        _OwnedTokensCount[to] += 1;

        emit Transfer(address(0), to, tokenId);
    }

}