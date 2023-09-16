// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

// Libraries
import { OrderStructs } from "../libraries/OrderStructs.sol";

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

    /**
     * @notice This function allows a user to execute a taker ask (against a maker bid) - auction
     * The bid price represents the maximum price that a buyer is willing to pay for security
     * @param takerAsk Taker ask struct
     * @param makerBid Maker bid struct
     * @param makerSignature Maker signature
     */
    function executeMakerBid(
        OrderStructs.Taker calldata takerAsk,
        OrderStructs.Maker calldata makerBid,
        bytes calldata makerSignature
    )
        external
        payable;

    /**
     * @notice This function allows a user to execute a taker bid (against a maker ask) - exchange
     * The ask price represents the minimum price that a seller is willing to take for that same security
     * @param takerBid Taker bid struct
     * @param makerAsk Maker ask struct
     * @param makerSignature Maker signature
     */
    function executeMakerAsk(
        OrderStructs.Taker calldata takerBid,
        OrderStructs.Maker calldata makerAsk,
        bytes calldata makerSignature
    )
        external
        payable;
}
