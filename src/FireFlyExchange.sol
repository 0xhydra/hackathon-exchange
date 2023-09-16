// SPDX-License-Identifier: MIT

pragma solidity 0.8.19;

// Interfaces
import { IFireFlyExchange } from "./interfaces/IFireFlyExchange.sol";
import { OrderStructs } from "./libraries/OrderStructs.sol";

contract FireFlyExchange is IFireFlyExchange {
    /**
     * @inheritdoc IFireFlyExchange
     */

    function executeMakerBid(
        OrderStructs.Taker calldata takerAsk,
        OrderStructs.Maker calldata makerBid,
        bytes calldata makerSignature
    )
        external
    { }

    /**
     * @inheritdoc IFireFlyExchange
     */
    function executeMakerAsk(
        OrderStructs.Taker calldata takerBid,
        OrderStructs.Maker calldata makerAsk,
        bytes calldata makerSignature
    )
        external
        payable
    { }
}
