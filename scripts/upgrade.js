async function main() {
    const NewMarketplaceV2 = await ethers.getContractFactory("NewMarketplaceV2")
    let newMarketplaceV2 = await upgrades.upgradeProxy("0x928f563F39830cbD623a80F4772E0f702D61e880", NewMarketplaceV2)
    console.log("Your upgraded proxy is done!", newMarketplaceV2.address)
}

main()
    .then(() => process.exit(0))
    .catch(error => {
        console.error(error)
        process.exit(1)
    })