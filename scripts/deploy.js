const hre = require("hardhat");
require("dotenv").config();
// ListingFees is set by default to 0.001 MATIC
const defaultListingFees = ethers.utils.parseUnits("0.0001", "ether");
// MarketPlace royalties is set by default to 2% ( 200 in basic point)
const defaultMarketplaceRoyalties = 200;
async function main() {
  // Deploy the smart contract
  const owner = await ethers.getSigner();

  // Deploy the market config first
  const MarketplaceCfg = await ethers.getContractFactory("MarketplaceConf");
  const marketplaceCfg = await MarketplaceCfg.deploy(
    defaultListingFees,
    defaultMarketplaceRoyalties
  );
  // Wait deploy to finish
  await marketplaceCfg.deployed();
  console.log(
    `marketplaceConf deployed to ${marketplaceCfg.address} with onwer address = ${owner.address}`
  );

  const Marketplace = await ethers.getContractFactory("Marketplace");
  const marketplace = await Marketplace.deploy(marketplaceCfg.address);
  await marketplace.deployed();
  console.log(
   `marketplace deployed to ${marketplace.address} with onwer address = ${owner.address}`
   );
  //proxy
  const NewMarketplace = await ethers.getContractFactory("NewMarketplace")
  console.log("Deploying Box, ProxyAdmin, and then Proxy...")
  const address= marketplace.address;
  const proxy = await upgrades.deployProxy(NewMarketplace, [address], { initializer: 'initialize' })
  console.log("Proxy of New Marketplace deployed to:", proxy.address)
  
  
  }


main()
  .then(() => process.exit(0))
  .catch(error => {
      console.error(error)
      process.exit(1)
  }) 