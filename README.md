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