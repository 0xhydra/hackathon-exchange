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
     * @param tokenId TokenId
     * @param currency Currency address (@dev address(0) = ETH)
     * @param price Minimum price for maker ask, maximum price for maker bid
     * @param signer Signer address
     * @param startTime Start timestamp
     * @param endTime End timestamp
     * @param items Array of items
     * @param values Array of values
     * @param makerSignature makerSignature (required);
     */
    struct Maker {
        QuoteType quoteType;
        uint256 orderNonce;
        CollectionType collectionType;
        address collection;
        uint256 tokenId;
        address currency;
        uint256 price;
        address signer;
        uint256 startTime;
        uint256 endTime;
        address[] assets;
        uint256[] values;
        bytes makerSignature;
    }

    /**
     * 2. Taker struct
     */

    /**
     * @notice Taker is the struct for a taker ask/bid order. It contains the parameters required for a direct purchase.
     * @dev Taker struct is matched against MakerAsk/MakerBid structs at the protocol level.
     * @param recipient Recipient address (to receive NFTs or non-fungible tokens)
     * @param takerSignature takerSignature(optional)
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
    // keccak256("Maker(uint8 quoteType,uint256 orderNonce,uint8 collectionType,address collection,uint256 tokenId,
    // address currency,uint256 price,address signer,uint256 startTime,uint256 endTime,uint256[] assets,uint256[]
    // values)")
    bytes32 internal constant _MAKER_TYPEHASH = 0xdcf35f40270bbc1d190bf2c174faf269abe7629a0f11e68c19228e0c1ae65fcc;

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
                    maker.tokenId,
                    maker.currency,
                    maker.price,
                    maker.signer,
                    maker.startTime,
                    maker.endTime,
                    keccak256(abi.encodePacked(maker.assets)),
                    keccak256(abi.encodePacked(maker.values))
                )
            )
        );
    }
}
