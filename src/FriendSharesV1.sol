pragma solidity >=0.8.2 <0.9.0;

interface FriendSharesV1 {
    /// @notice Returns the number of `subject` shares that `holder` holds
    ///
    /// @param subject The subject of the shares
    /// @param holder  The holder of the shares
    ///
    /// @return shares The number of `subject` shares that `holder` holds
    function sharesBalance(address subject, address holder) external view returns (uint256 shares);

    /// @notice Returns the number of total number of shares that exist for `subject`
    ///
    /// @param subject The subject of the shares
    ///
    /// @return totalSupply The total number of shares that exist for `subject`
    function sharesSupply(address subject) external view returns (uint256 totalSupply);

    /// @notice Returns the amount of ether that purchasing `amount` shares of `subject` costs without accounting for fees
    ///
    /// @param subject The subject of the shares
    /// @param amount  The number of shares
    ///
    /// @return value The amount of ether that purchasing `amount` shares of `subject` would cost
    function getBuyPrice(address subject, uint256 amount) external view returns (uint256 value);

    /// @notice Returns the amount of ether that selling `amount` shares of `subject` returns without accounting for fees
    ///
    /// @param subject The subject of the shares
    /// @param amount  The number of shares
    ///
    /// @return value The amount of ether that selling `amount` shares of `subject` would return
    function getSellPrice(address subject, uint256 amount) external view returns (uint256 value);

    /// @notice Returns the amount of ether that purchasing `amount` shares of `subject` costs after accounting for fees
    ///
    /// @param subject The subject of the shares
    /// @param amount  The number of shares
    ///
    /// @return value The amount of ether that purchasing `amount` shares of `subject` would cost
    function getBuyPriceAfterFee(address subject, uint256 amount) external view returns (uint256 value);

    /// @notice Returns the amount of ether that selling `amount` shares of `subject` returns after accounting for fees
    ///
    /// @param subject The subject of the shares
    /// @param amount  The number of shares
    ///
    /// @return value The amount of ether that selling `amount` shares of `subject` would return
    function getSellPriceAfterFee(address subject, uint256 amount) external view returns (uint256 value);

    /// @notice Buys `amount` shares of `subject`
    ///
    /// @param subject The subject of the shares
    /// @param amount  The number of shares to buy
    function buyShares(address subject, uint256 amount) external payable;

    /// @notice Sells `amount` shares of `subject`
    ///
    /// @param subject The subject of the shares
    /// @param amount  The number of shares to sell
    function sellShares(address subject, uint256 amount) external payable;
}