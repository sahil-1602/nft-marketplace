// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import './ERC165.sol';
import './interfaces/IERC721.sol';


    /*

    Building out the minting funtion:
        a. nft point to an address
        b. keep track of the token ids
        c. keep track of token owner address to token ids
        d. keep track of how many tokens an owner address has
        e. create an event that emits a tranfer log - contract address,
            where it is being minted to, the id

    */


contract ERC721 is ERC165, IERC721 {

    // Mapping from token id to the owner
    mapping(uint256 => address) private _tokenOwner;

    // Mapping from owner to number of owned tokens
    mapping(address => uint256) private _OwnedTokensCount;

    // Mapping from token id to approved addresses
    mapping(uint256 => address) private _tokenApprovals;

    constructor() {
        _registerInterface(bytes4(
            keccak256('balanceOf(bytes4)')^
            keccak256('ownerOf(bytes4)')^
            keccak256('transferFrom(bytes4)')
        ));
    }

    function balanceOf(address _owner) public view override returns(uint256) {
        require(_owner != address(0), 'ERC721: Address cannot be zero');
        return _OwnedTokensCount[_owner];
    }

    function ownerOf(uint256 _tokenId) public view override returns (address) {
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

    function _mint(address to, uint256 tokenId) internal virtual {
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

    function _transferFrom(address _from, address _to, uint256 _tokenId) internal {
        // checks for invalid address
        require(_to != address(0), 'ERC721: receiving address zero');
        require(_from != address(0), 'ERC721: sending address zero');
        // checking if the _from address owns the token
        require(ownerOf(_tokenId) == _from, 'ERC721: Owner address does not own the specified token');
        
         // update the balance of the address _from token
        _OwnedTokensCount[_from] -= 1;

        // update the balance of the address _to
        _OwnedTokensCount[_to] += 1;

        // add the token id to the address receiving the token
        _tokenOwner[_tokenId] = _to;

        emit Transfer(_from, _to, _tokenId);
    }

    function transferFrom(address _from, address _to, uint256 _tokenId) override public {
        require(isApprovedOrOwner(msg.sender, _tokenId));
        _transferFrom(_from, _to, _tokenId);
    }


    // 1. Require that the person approving is the owner
    // 2. We are approving an address to a token (tokenId)
    // 3. Require that cant approve sending tokens of the owner to the owner (current caller)
    // 4. update the map of the approval addresses.
    function approve(address _to, uint256 tokenId) public {
        address owner = ownerOf(tokenId);
        require(_to != owner, 'Error = approval to current owner');
        require(msg.sender == owner, 'Current caller is not the owner of the token');
        _tokenApprovals[tokenId] = _to;

        emit Approval(owner, _to, tokenId);
    }

    function isApprovedOrOwner(address spender, uint256 tokenId) internal view returns(bool) {
        require(_exists(tokenId), 'token does not exist');
        address owner = ownerOf(tokenId);
        return spender == owner;
    }

}