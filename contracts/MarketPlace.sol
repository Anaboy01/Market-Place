// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.27;

contract MyMarket {
    address public contractOwner;

    enum OrderStatus {
        None,
        Created,
        Pending,
        Sold
    }

    struct Asset {
        string assetName;
        uint16 assetPrice;
        address assetSeller;
        OrderStatus status;
    }

    Asset[] public listedAssets;
    mapping(uint256 => bool) public assetIsSold;

    event AssetListed(string indexed assetName, uint16 assetPrice, address indexed assetSeller);
    event AssetSold(string indexed assetName, uint16 assetPrice, address indexed assetBuyer);

    constructor() {
        contractOwner = msg.sender;
    }

    function listAsset(string memory _assetName, uint16 _assetPrice) external {
        require(msg.sender != address(0), "Zero address is not allowed");
        require(_assetPrice > 0, "Price must be greater than zero");

        Asset memory newAsset;
        newAsset.assetName = _assetName;
        newAsset.assetPrice = _assetPrice;
        newAsset.assetSeller = msg.sender;
        newAsset.status = OrderStatus.Created;

        listedAssets.push(newAsset);

        emit AssetListed(_assetName, _assetPrice, msg.sender);
    }

    function purchaseAsset(uint256 _assetIndex) external payable {
        require(msg.sender != address(0), "Zero address is not allowed");
        require(_assetIndex < listedAssets.length, "Out of bounds!");
        require(!assetIsSold[_assetIndex], "Asset already sold");

        Asset storage assetToPurchase = listedAssets[_assetIndex];

        require(msg.value == uint256(assetToPurchase.assetPrice) * 1 ether, "Incorrect amount of Ether sent");
        require(assetToPurchase.status == OrderStatus.Created, "Asset is not available for purchase");

     
        assetToPurchase.status = OrderStatus.Sold;
        assetIsSold[_assetIndex] = true;

        (bool sent, ) = payable(assetToPurchase.assetSeller).call{value: msg.value}("");
        require(sent, "Failed to transfer Ether to the seller");

        emit AssetSold(assetToPurchase.assetName, assetToPurchase.assetPrice, msg.sender);
    }

    function getListedAssets() public view returns (Asset[] memory) {
        return listedAssets;
    }

    receive() external payable {}
    fallback() external payable {}
}
