// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract Bank is ERC721 {
    uint256 lastToken = 0;

    mapping(string => uint256) tokenByHash;

    mapping(uint256 => string) hashByToken;
    mapping(uint256 => string) tagsByToken;
    mapping(uint256 => uint256) votesByToken;

    constructor() ERC721("Stickorz", "STCKRZ") {}

    function tokenOf(string memory _hash) external view returns (uint256){
        return tokenByHash[_hash];
    }

    function hashOf(uint256 _token) external view returns (string memory){
        return hashByToken[_token];
    }

    function tagsOf(uint256 _token) external view returns (string memory){
        return tagsByToken[_token];
    }

    function votesOf(uint256 _token) external view returns (uint256) {
        return votesByToken[_token];
    }

    event Mint(address indexed owner, uint256 indexed token, string tags);

    function mint(address _to, string memory _hash, string memory _tags) external returns (uint256) {
        require(tokenByHash[_hash] == 0, "Bank: Hash already exists");

        uint256 token = ++lastToken;

        _safeMint(_to, token);
        hashByToken[token] = _hash;
        tagsByToken[token] = _tags;
        tokenByHash[_hash] = token;

        emit Mint(_to, token, _tags);

        return lastToken;
    }

    event Upvote(address indexed sender, uint256 indexed token, uint256 amount);

    function upvote(uint256 _token) external payable {
        require(_token > 0, "Bank: Invalid token");
        require(msg.value > 0, "Bank: Invalid amount");

        votesByToken[_token] += msg.value;

        emit Upvote(msg.sender, _token, msg.value);
    }
}