pragma solidity 0.8.21;

import {Owned} from "solmate/auth/Owned.sol";
import {ERC1155} from "solmate/tokens/ERC1155.sol";
import {SafeTransferLib} from "solmate/utils/SafeTransferLib.sol";

import {FriendSharesV1} from "./FriendSharesV1.sol";

contract SemiFungibleFriendShares is ERC1155, Owned {
    using SafeTransferLib for address;

    /// @notice Emitted when the default URI is set to `value`
    event DefaultURI(string value);

    /// @notice The `FriendSharesV1` contract that this contract wraps
    FriendSharesV1 public immutable shares;

    /// @notice A flag indicating if the contract reentrancy lock is unclaimed
    bool public unlocked = true;

    /// @notice The default URI to return for token ids that have not had their URI set
    string public defaultURI;

    /// @notice The metadata URI overrides for the token with id `id`
    mapping(uint256 id => string uri) public uriOverrides;

    /// @dev Engages the reentrancy lock
    modifier lock() {
        require(unlocked, "LOCKED");
        unlocked = false;
        _;
        unlocked = true;
    }

    constructor(FriendSharesV1 shares_) Owned(msg.sender) {
        shares = shares_;
    }

    /// @notice Returns the metadata URI of the token with id `id`
    function uri(uint256 id) public view override returns (string memory) {
        string memory overrideURI = uriOverrides[id];
        return bytes(overrideURI).length > 0 ? uriOverrides[id] : defaultURI;
    }

    /// @notice Returns the token id for `subject`
    function getTokenId(address subject) public pure returns (uint256 id) {
        id = uint256(uint160(subject));
    }

    /// @notice Sets the default URI to return for token ids that have not had their URI set
    function setDefaultURI(string memory value) external onlyOwner {
        defaultURI = value;
        emit DefaultURI(value);
    }

    /// @notice Allows `msg.sender` to set their token URI to `value`
    function setURI(string memory value) external {
        uint256 id;
        uriOverrides[(id = getTokenId(msg.sender))] = value;

        emit URI(value, id);
    }

    /// @notice Returns the amount of ether that purchasing `amount` shares of `subject` would cost
    ///
    /// @param subject The subject of the shares
    /// @param amount  The number of shares to purchase
    ///
    /// @return cost The amount of ether that purchasing `amount` shares of `subject` costs
    function previewPurchase(address subject, uint256 amount) public view returns (uint256 cost) {
        cost = shares.getBuyPriceAfterFee(subject, amount);
    }

    /// @notice Returns the amount of ether that selling `amount` shares of `subject` would return
    ///
    /// @param subject The subject of the shares
    /// @param amount  The number of shares to sell
    ///
    /// @return proceeds The amount of ether that selling `amount` shares of `subject` returns
    function previewRedeem(address subject, uint256 amount) public view returns (uint256 proceeds) {
        proceeds = shares.getSellPriceAfterFee(subject, amount);
    }

    /// @notice Purchase `amount` shares of `subject` and mint them to `recipient`
    ///
    /// @param subject     The subject of the shares
    /// @param amount      The number of shares to purchase
    /// @param recipient   The recipient of the shares
    /// @param maximumCost The maximum amount of ether to spend on the purchase
    /// @param data        The data to pass to `receiver` through the `ERC1155TokenReceiver` callback function if a contract
    ///
    /// @return cost The amount of ether spent on the purchase
    function purchase(
        address subject,
        uint256 amount,
        address recipient,
        uint256 maximumCost,
        bytes memory data
    ) external payable lock returns (uint256 cost) {
        require(amount > 0, "INVALID_AMOUNT");

        cost = previewPurchase(subject, amount);
        require(cost <= maximumCost, "EXCESSIVE_COST");

        shares.buyShares{value: cost}(subject, amount);

        _mint(recipient, getTokenId(subject), amount, data);

        if (address(this).balance > 0) {
            msg.sender.safeTransferETH(address(this).balance);
        }
    }

    /// @notice Redeem `amount` shares of `subject` and transfer the proceeds to `recipient`
    ///
    /// @param subject         The subject of the shares
    /// @param amount          The number of shares to sell
    /// @param recipient       The recipient of the proceeds
    /// @param minimumProceeds The minimum amount of ether to receive from the sale
    ///
    /// @return proceeds The amount of ether received from the sale
    function redeem(
        address subject,
        uint256 amount,
        address recipient,
        uint256 minimumProceeds
    ) external lock returns (uint256 proceeds) {
        require(amount >= 0, "INVALID_AMOUNT");

        proceeds = previewRedeem(subject, amount);
        require(proceeds >= minimumProceeds, "INSUFFICIENT_PROCEEDS");

        shares.sellShares(subject, amount);

        _burn(recipient, getTokenId(subject), amount);

        recipient.safeTransferETH(proceeds);
    }
}