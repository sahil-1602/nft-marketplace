// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import './ERC721.sol';
import './interfaces/IERC721Enumerable.sol';

contract ERC721Enumerable is ERC721, IERC721Enumerable {

    uint256[] private _allTokens;

    // mapping from tokenId to position in _allTokens array
    mapping(uint256 => uint256) private _allTokensIndex;

    // mapping of owner to list of all owner token ids
    mapping(address => uint256[]) private _ownedTokens;

    // mapping from token ID index of the owner tokens list
    mapping(uint256 => uint256) private _ownedTokensIndex;

    constructor() {
        _registerInterface(bytes4(
            keccak256('totalSupply(bytes4)')^
            keccak256('tokenByIndex(bytes4)')^
            keccak256('tokenOfOwnerByIndex(bytes4)')
        ));
    }

    function _mint(address to, uint256 tokenId) internal override(ERC721) {
        super._mint(to, tokenId);

        // A. Add tokens to the owner
        // B. All tokens to our totalsupply - to allTokens

        _addTokensToAllTokenEnumeration(tokenId);
        _addTokensToOwnerEnumeration(to, tokenId);
    }


    // add tokens to the _allTokens array and set the position of the tokens indexes
    function _addTokensToAllTokenEnumeration(uint256 tokenId) private {
        _allTokensIndex[tokenId] = _allTokens.length;
        _allTokens.push(tokenId);
    }

    
    function _addTokensToOwnerEnumeration(address to, uint256 tokenId) private {
        // ownedTokensIndex tokenId set to address of ownedTokens position
        _ownedTokensIndex[tokenId] = _ownedTokens[to].length;
        // add address and tokenId to the _ownedTokens
        _ownedTokens[to].push(tokenId);
    }

    // return the total supply of _allTokens array
    function totalSupply() public view override returns (uint256) {
        return _allTokens.length;
    }


    // returns tokenByIndex
    function tokenByIndex(uint256 index) public view override returns(uint256) {
        require(index < totalSupply(), 'global index is out of bounds!');
        return _allTokens[index];
    }

    // returns tokenOfOwnerByIndex
    function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns(uint256) {
        require(owner != address(0), 'owner address zero');
        require(index < balanceOf(owner), 'owner index is out of bounds!');
        return _ownedTokens[owner][index];
    }

}