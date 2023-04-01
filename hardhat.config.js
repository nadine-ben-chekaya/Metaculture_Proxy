require("@nomicfoundation/hardhat-toolbox");
require('@openzeppelin/hardhat-upgrades');
require("dotenv").config();

/** @type import('hardhat/config').HardhatUserConfig */
const {
  MUMBAI_API_URL,
  PRIVATE_KEY_ACCOUNT3,
  Goerli_API_URL
} = process.env;
module.exports = {
  solidity: "0.8.18",
  networks: {
    mumbai:{
       url: MUMBAI_API_URL,
       accounts: [`${PRIVATE_KEY_ACCOUNT3}`],
       },
    goerli:{
        url: Goerli_API_URL,
        accounts: [`${PRIVATE_KEY_ACCOUNT3}`],
        },
  }
};
