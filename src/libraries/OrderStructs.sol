// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

// Enums
import { CollectionType } from "../enums/CollectionType.sol";
import { QuoteType } from "../enums/QuoteType.sol";

/**
 * @title OrderStructs
 * @notice This library contains all order struct types for the Firefly exchange
 * @author Firefly exchange
 */
library OrderStructs {
    /**
     * 1. Order struct
     */

    /**
     * @notice Maker is the struct for a maker order.
     * @param quoteType Quote type (i.e. 0 = BID, 1 = ASK)
     * @param orderNonce Order nonce (it can be shared across bid/ask maker orders)
     * @param collectionType Collection type (i.e. 0 = ERC721, 1 = ERC6551)
     * @param collection Collection address
     * @param currency Currency address (@dev address(0) = ETH)
     * @param price Minimum price for maker ask, maximum price for maker bid
     * @param signer Signer address
     * @param startTime Start timestamp
     * @param endTime End timestamp
     * @param items Array of items
     * @param tokenIds Array of tokenIds
     */
    struct Maker {
        QuoteType quoteType;
        uint256 orderNonce;
        CollectionType collectionType;
        address collection;
        address currency;
        uint256 price;
        address signer;
        uint256 startTime;
        uint256 endTime;
        address[] items;
        uint256[] tokenIds;
    }

    /**
     * 2. Taker struct
     */

    /**
     * @notice Taker is the struct for a taker ask/bid order. It contains the parameters required for a direct purchase.
     * @dev Taker struct is matched against MakerAsk/MakerBid structs at the protocol level.
     * @param recipient Recipient address (to receive NFTs or non-fungible tokens)
     * @param taker Extra data specific for the order
     */
    struct Taker {
        address recipient;
        bytes takerSignature;
    }

    /**
     * 3. Constants
     */

    /**
     * @notice This is the type hash constant used to compute the maker order hash.
     */
    // keccak256("MakerOrder(uint8 quoteType,uint256 orderNonce,uint8 collectionType,address
    // collection,address currency,uint256 price,address signer,uint256 startTime,uint256 endTime,uint256[]
    // items,uint256[] tokenIds")
    bytes32 internal constant _MAKER_TYPEHASH = 0x02ad754d807b2e74cb60c9192567a860b088907ad71511ce6877d595aa4bfe51;

    /**
     * 5. Hash functions
     */

    /**
     * @notice This function is used to compute the order hash for a maker struct.
     * @param maker Maker order struct
     * @return makerHash Hash of the maker struct
     */
    function hash(Maker memory maker) internal pure returns (bytes32) {
        // Encoding is done into two parts to avoid stack too deep issues
        return keccak256(
            bytes.concat(
                abi.encode(
                    _MAKER_TYPEHASH,
                    maker.quoteType,
                    maker.orderNonce,
                    maker.collectionType,
                    maker.collection,
                    maker.currency,
                    maker.price,
                    maker.signer,
                    maker.startTime,
                    maker.endTime,
                    keccak256(abi.encodePacked(maker.items)),
                    keccak256(abi.encodePacked(maker.tokenIds))
                )
            )
        );
    }
}
