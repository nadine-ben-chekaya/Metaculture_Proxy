// SPDX-License-Identifier: MIT
pragma solidity >= 0.6.0;
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";

import "@openzeppelin/contracts-upgradeable/utils/math/SafeMathUpgradeable.sol";
import "./Collection.sol";
import "./NFTErrors.sol";
interface IMarketplaceConf {
    function getListingFees() external view returns (uint256);
    function setArtistRoyalties(address _collectionAdr, uint256 nftId, uint16 _artistRoyalties) external;
    function setCuratorRoyalties(address _collectionAdr, uint16 _curatorRoyalties) external;
    function getAllShares(
        address _collectionAdr,
        uint256 _nftId,
        uint256 _price
        ) external view returns (uint256, uint256, address, uint256, uint256);
}

interface IMarketplace {
    function _collectionExists(address _adr) external;
    function _onlyOwner() external;
    function createCollection(string memory _collectionName, string memory _symbole) external returns (address);
    function createNft(
        bool _isForSale,
        uint16 _royaltiesArtist,
        address _collectionAdr,
        uint256 _price,
        string memory _nftUri
        ) external returns (uint256 nftId) ;
        
        function sellNft(
            address payable _collectionAdr,
            uint256 _nftId,
            uint256 _price
            ) external;
             
        function cancelSaleNft(address payable _collectionAdr, uint256 _nftId) external;
        function buyNft(address _collectionAdr,uint256 _nftId,uint256 _price) external;
        function totalSupply() external returns (uint256) ;
        function getCurrentListingFees() external view returns (uint256) ;
}

contract NewMarketplaceV2{
    address payable private owner;
    address private marketplaceAdr;
    uint256 private listingFees;
    uint256 private value;
    event NewCollectionAdded(address collectionAddress, string name); 
    mapping(address => bool) private collections;
    function initialize(address _marketaddress) public {
        marketplaceAdr = _marketaddress;
        listingFees = IMarketplace(marketplaceAdr).getCurrentListingFees();
       // value= _value;
    }
   
     
 
 
    // Reads the last stored value
    function retrieve() public view returns (uint256) {
        
        return listingFees;
    }

    function listingfeesplus() public{
           listingFees = listingFees + 1;
    }

    function NewcreateCollection(string memory _collectionName, string memory _symbole) public returns (address){
          address collectionadd = IMarketplace(marketplaceAdr).createCollection(_collectionName,  _symbole);
          emit NewCollectionAdded(collectionadd, _collectionName);
          return(collectionadd);
    }

   
    
 }




