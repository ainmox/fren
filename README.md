# Fren

Miscellaneous utilities for [friend.tech](friend.tech) smart contracts. All contracts are meant to serve as 
public goods and are free to use.

## :warning: Warning :warning:

None of these smart contracts are audited. Use at your own risk.

## Contracts 

### Semi-fungible Wrapper

This contract allows you purchase and wrap a shares into a semi-fungible token (ERC-1155). 
The wrapped shares can be redeemed at any time. Wrapping the shares in this format 
allows for transfers and integration in other contracts that support the ERC-1155 standard 
(Blur, OpenSea, Sudoswap).

The wrapper includes slight improvements over the base friend.tech shares contract. When purchasing
shares, any excess ether is refunded to the sender. To prevent frontrunning when purchasing or redeeming shares, a 
parameter can be specified to revert the call if the amount of ether spend or received is within an expected range.

The only centralized action that the deployer can make is to set the default URI. Users are 
able to override the default URI at any time.

*If you wrap shares in this contract, you will not be able to use the subject's chatroom. For this reason it is
recommended that you only use this contract if you are a power user.*