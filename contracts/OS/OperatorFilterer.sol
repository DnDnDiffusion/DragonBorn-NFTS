// SPDX-License-Identifier: MIT

// solhint-disable-next-line
pragma solidity ^0.8.13;

import {IOperatorFilterRegistry} from "./IOperatorFilterRegistry.sol";

abstract contract OperatorFilterer {
  error OperatorNotAllowed(address operator);

  IOperatorFilterRegistry constant OPERATOR_FILTER_REGISTRY =
    IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);

  constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
    // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
    // will not revert, but the contract will need to be registered with the registry once it is deployed in
    // order for the modifier to filter addresses.
    if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
      if (subscribe) {
        OPERATOR_FILTER_REGISTRY.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
      } else {
        if (subscriptionOrRegistrantToCopy != address(0)) {
          OPERATOR_FILTER_REGISTRY.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
        } else {
          OPERATOR_FILTER_REGISTRY.register(address(this));
        }
      }
    }
  }

  modifier onlyAllowedOperator(address from) virtual {
    // Check registry code length to facilitate testing in environments without a deployed registry.
    if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
      // Allow spending tokens from addresses with balance
      // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
      // from an EOA.
      if (from == msg.sender) {
        _;
        return;
      }
      if (
        !(OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), msg.sender) &&
          OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), from))
      ) {
        revert OperatorNotAllowed(msg.sender);
      }
    }
    _;
  }
}
