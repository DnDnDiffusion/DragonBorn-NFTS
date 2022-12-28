// contracts/GameItem.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Royalty.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract DragonBornNFT is
    ERC721URIStorage,
    Ownable,
    ERC721Royalty,
    AccessControl
{
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    event newCharacter(uint256 tokenId, address player, string tokenURI);

    constructor() ERC721("DragonBornToken", "DBT") {}

    function tokenURI(uint256 tokenId)
        public
        view
        virtual
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }

    function _burn(uint256 tokenId)
        internal
        override(ERC721URIStorage, ERC721Royalty)
    {
        super._burn(tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Royalty, AccessControl)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }

    function createRpgCharacter(address player, string memory _tokenURI)
        public
        onlyOwner
        returns (uint256)
    {
        uint256 newItemId = _tokenIds.current();
        _mint(player, newItemId);
        _setTokenURI(newItemId, _tokenURI);
        emit newCharacter(newItemId, player, _tokenURI);
        _tokenIds.increment();
        return newItemId;
    }

    function createRpgCharacterPublic(string memory _tokenURI)
        public
        returns (uint256)
    {
        address player = msg.sender;
        uint256 newItemId = _tokenIds.current();
        _mint(player, newItemId);
        _setTokenURI(newItemId, _tokenURI);
        emit newCharacter(newItemId, player, _tokenURI);
        _tokenIds.increment();
        return newItemId;
    }
}
