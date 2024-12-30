// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DynamicNFT{
    uint private tokenIdCounter;
    //base URI for the matadata storage
    string private baseURI;

    constructor(string memory _baseURI){
        baseURI =_baseURI;
        tokenIdCounter = 1;
    }

    mapping (uint => address) private TokenOwner;
    mapping (uint => string)private TokenURI;
    mapping (uint => uint)private TokenLevel;

    event MintToken(address indexed  to, uint tokenId,string tokenURI);


    // FUNCTION

    function ownerOf(uint tokenId)public view returns(address){
        return TokenOwner[tokenId];
    }

    function URItoken(uint tokenId)public view returns (string memory){
        return TokenURI[tokenId];
    }

    //convert uint to string
    function uint2str(uint _i)internal  pure returns(string memory uintAsString){
        if(_i ==0){
            return "0";
        }

        uint temp = _i;
        uint digits;
        //count the no of digits in number
        while (temp != 0){
            digits++;
            temp /=10;
        }

        bytes memory result = new bytes(digits);
        uint index = digits - 1;
        while(_i != 0){
            result[index--]= bytes1(uint8(48 + _i %10));
            _i /=10;
        }
        return  string(result);
    }

    function mint(address to)public returns (uint){
        uint tokenId = tokenIdCounter;
        require(to != address(0));

        TokenOwner[tokenId] = to;
        
        //set the token URI
        string memory URI = string(abi.encodePacked(baseURI, uint2str(tokenId)));
        TokenURI[tokenId] = URI;

        //set initial level
        TokenLevel[tokenId] =1;

        emit MintToken(to, tokenId, URI);
        tokenIdCounter++;
        return  tokenId;
    }
}