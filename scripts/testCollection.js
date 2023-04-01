const hre = require("hardhat");
const { ethers, upgrades } = require("hardhat");
// defaultListingFees is set by default to 0.0001 MATIC
const defaultListingFees = ethers.utils.parseUnits("0.0001", "ether");
// defaultNftPrice is set by default to 0.001 MATIC
const defaultNftPrice = ethers.utils.parseUnits("0.001", "ether");
// defaultArtistRoyalties is set by default to 2.2%
const defaultArtistRoyalties = 220;
// load json file
const contractJson = require("../artifacts/contracts/Upgrade.sol/Upgrade.json");
// load ABI application binary interface
const abi = contractJson.abi;

async function main() {
  const alchemy = new hre.ethers.providers.AlchemyProvider(
    "maticmum",
    process.env.ALCHEMY_API_KEY
  );
  const userWallet = new hre.ethers.Wallet(process.env.PRIVATE_KEY_ACCOUNT3, alchemy);
  const Upgrade = new hre.ethers.Contract(
    process.env.CONTRACT_ADDRESS_MARKET,
    abi,
    userWallet
  );

  const gasPriceOracle = "https://gasstation-mainnet.matic.network/";
  const gasPrice = await ethers.provider.getGasPrice(gasPriceOracle);

 

  const gasprice = ethers.utils.parseUnits('152', 'gwei');
  owner = await Upgrade.getOwner();
  console.log(owner);

  const estimate2 = await Upgrade.estimateGas.getCurrentListingFees(defaultListingFees);
  const tx1Promise = Upgrade.getCurrentListingFees(
  defaultListingFees,
    {
      gasPrice: gasPrice,
      gasLimit: estimate2.mul(2), // Double the estimated gas limit
    }
  );
  console.log(tx1Promise);

  const tx1 = await tx1Promise;
  console.log(tx1);
  await tx1.wait();

  
//const tx1 ;
tx1.then(() => {
  return Upgrade.getCurrentListingFees(
    123,
    {gasPrice: gasPrice,
    gasLimit: estimate2.mul(2), // Double the estimated gas limit
    });
  });

 
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exitCode = 1;
  });