// SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@shamba/contracts/polygon/mumbai-testnet/ShambaGeoConsumer.sol";

contract PolyAirQuality is ERC721URIStorage, ShambaGeoConsumer {
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;

    int256 currentGeostats;

    string[] IpfsUri = [
        "https://bafybeigf6dd7f3vnw5q7vvl2n5blk3ex4g55r2b7vshjs6cu2gbghnp7be.ipfs.dweb.link/no-data-emoji.json",
        "https://bafybeifgoedfpeuhiyhe4mw24bzcizzcjryvceubujosi2n4xe37o7brgi.ipfs.dweb.link/good-air-quality-emoji.json",
        "https://bafybeifgoedfpeuhiyhe4mw24bzcizzcjryvceubujosi2n4xe37o7brgi.ipfs.dweb.link/intermediate-air-quality-emoji.json",
        "https://bafybeifgoedfpeuhiyhe4mw24bzcizzcjryvceubujosi2n4xe37o7brgi.ipfs.dweb.link/bad-air-quality-emoji.json"
    ];

    constructor() ERC721("AIR-QUALITY-dNFTs", "dNFT") {}

    function checkGeostats(
        string memory agg_x,
        string memory dataset_code,
        string memory selected_band,
        string memory image_scale,
        string memory start_date,
        string memory end_date,
        Geometry[] memory geometry
    ) private {
        //First build up a request to get the current geostats
        ShambaGeoConsumer.requestGeostatsData(
            agg_x,
            dataset_code,
            selected_band,
            image_scale,
            start_date,
            end_date,
            geometry
        );
    }

    /**
     * @dev
     * This function will return the latest content id of the metadata that is being stored on the filecoin ipfs
     */

    function getLatestCid() public view returns (string memory) {
        return ShambaGeoConsumer.getCid(total_oracle_calls - 1);
    }

    /**
     * @dev
     * This function will return the current geostats data returned by the getGeostatsData function of the imported ShambaGeoConsumer contract
     */

    function getShambaGeostatsData() public view returns (int256) {
        return ShambaGeoConsumer.getGeostatsData();
    }

    function safeMint(address to) public {
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(to, tokenId);
        _setTokenURI(tokenId, IpfsUri[0]);
    }

    function update_dNFT() public {
        string memory newUri;
        uint256 _tokenId = 0;

        currentGeostats = ShambaGeoConsumer.getGeostatsData();
        if (currentGeostats != 0) {
            if (currentGeostats <= 0.3 * 10**17) {
                // Good Air Quality
                newUri = IpfsUri[1];
            } else if (
                currentGeostats > 0.3 * 10**17 && currentGeostats < 0.4 * 10**17
            ) {
                // Intermediate Air Quality
                newUri = IpfsUri[2];
            } else {
                // Bad Air Quality
                newUri = IpfsUri[3];
            }

            _setTokenURI(_tokenId, newUri);
        }
    }
}
