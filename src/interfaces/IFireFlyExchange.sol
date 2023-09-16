// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

// Libraries
import { OrderStructs } from "src/libraries/OrderStructs.sol";

/**
 * @title IFireFlyExchange
 * @author FireFly team
 */
interface IFireFlyExchange {
    error Exchange__ZeroValue();
    error Exchange__OutOfRange();
    error Exchange__InvalidNonce();
    error Exchange__InvalidCurrency();
    error Exchange__InvalidCollection();
    error Exchange__InvalidSigner();
    error Exchange__InvalidAsset();
    error Exchange__LengthMisMatch();

    /**
     * @notice
     * Auction: allows a user to execute a taker ask (against a maker bid)
     * The bid price represents the maximum price that a buyer is willing to pay for security
     *
     * Exchange: function allows a user to execute a taker bid (against a maker ask)
     * The ask price represents the minimum price that a seller is willing to take for that same security
     * @param maker Taker struct
     * @param taker Maker struct
     */
    function executeOrder(OrderStructs.Maker calldata maker, OrderStructs.Taker calldata taker) external payable;
}
