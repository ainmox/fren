# Fren

Miscellaneous utilities for [friend.tech](friend.tech) smart contracts. All contracts are meant to serve as 
public goods and are free to use.

## :warning: Warning

None of these smart contracts are audited. Use at your own risk.

## Contracts 

### Semi-fungible Wrapper

This contract allows you purchase and wrap a shares into a semi-fungible token (ERC-1155). 
The wrapped shares can be redeemed at any time. Wrapping the shares in this format 
allows for transfers and integration in other contracts that support the ERC-1155 standard 
(Blur, OpenSea, Sudoswap).

The only centralized action that the deployer can make is to set the default URI. Users are 
able to override the default URI at any time.

*If you wrap shares in this contract, you will not be able to use the subject's chatroom.*