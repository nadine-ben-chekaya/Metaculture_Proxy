// SPDX-License-Identifier: MIT
pragma solidity >= 0.6.0;
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/math/SafeMathUpgradeable.sol";
import "./Collection.sol";
import "./NFTErrors.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
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
        function getOwner() external view returns (address);
}
contract NewMarketplaceV2 {
    address payable private owner;
    address private marketplaceAdr;
    uint256 private listingFees;
    uint256 private value;
    event NewCollectionAdded(address collectionAddress, string name); 
    event NewNftAdded(address collection, uint256 nftId );
    mapping(address => bool) private collections;
    function initialize(address _marketaddress) public {
        marketplaceAdr = _marketaddress;
        listingFees = IMarketplace(marketplaceAdr).getCurrentListingFees();
       // value= _value;
    }
    uint256 private secListingFees;
    address collectionadd;
   
     
 
 
    // Reads the last stored value
    function retrieve() public view returns (uint256) {
        
        return listingFees;
    }

    function listingfeesplus() public{
           listingFees = listingFees + 1;
    }

    function NewcreateCollection(string memory _collectionName, string memory _symbole) public returns (address){
          collectionadd = IMarketplace(marketplaceAdr).createCollection(_collectionName,  _symbole);
          emit NewCollectionAdded(collectionadd, _collectionName);
          return(collectionadd);
    }
    
    function SecListing() public {
        secListingFees= IMarketplace(marketplaceAdr).getCurrentListingFees();
    }

    function GetSeclisting()public view returns(uint256){
        return secListingFees;
    }

    function NewcreateNFT(bool _isForSale,
        uint16 _royaltiesArtist,
        address _collectionAdr,
        uint256 _price,
        string memory _nftUri) public returns (uint256){
          uint256 nftid = IMarketplace(marketplaceAdr).createNft(_isForSale, _royaltiesArtist, _collectionAdr, _price, _nftUri);
          emit NewNftAdded(collectionadd, nftid);
          return(nftid);
    }
    
    //Auction
  
    event Start();
    event End(address highestBidder, uint highestBid);
    event Bid(address indexed sender, uint amount);
    event Withdraw(address indexed bidder, uint amount);

    address payable public seller;

    bool public started;
    bool public ended;
    uint public endAt;

    IERC721 public nft;
    uint public nftId;

    uint public highestBid;
    address public highestBidder;
    mapping(address => uint) public bids;
    function start(IERC721 _nft, uint _nftId, uint startingBid) external {
        require(!started, "Already started!");
        seller = payable(IMarketplace(marketplaceAdr).getOwner());
        require(msg.sender == seller, "You did not start the auction!");
        highestBid = startingBid;

        nft = _nft;
        nftId = _nftId;
        nft.transferFrom(msg.sender, address(this), nftId);

        started = true;
        endAt = block.timestamp + 2 days;

        emit Start();
    }

    function bid() external payable {
        require(started, "Not started.");
        require(block.timestamp < endAt, "Ended!");
        require(msg.value > highestBid);

        if (highestBidder != address(0)) {
            bids[highestBidder] += highestBid;
        }

        highestBid = msg.value;
        highestBidder = msg.sender;

        emit Bid(highestBidder, highestBid);
    }

    function withdraw() external payable {
        uint bal = bids[msg.sender];
        bids[msg.sender] = 0;
        payable(msg.sender).transfer(bal);

        emit Withdraw(msg.sender, bal);
    }

    function end() external {
        require(started, "You need to start first!");
        require(block.timestamp >= endAt, "Auction is still ongoing!");
        require(!ended, "Auction already ended!");

        if (highestBidder != address(0)) {
            nft.transferFrom(address(this),highestBidder, nftId);
            (bool sent, bytes memory data) = seller.call{value: highestBid}("");
            require(sent, "Could not pay seller!");
        } else {
            nft.transferFrom(address(this), seller, nftId);
        }

        ended = true;
        emit End(highestBidder, highestBid);
    }
   
    
 }




