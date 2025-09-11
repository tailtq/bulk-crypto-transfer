# BulkTransfer - Airdrop Tool

A Solidity smart contract for efficient bulk token and ETH transfers, perfect for airdrops, batch payments, and mass distributions.

## Features

- **Bulk ERC20 Token Transfers**: Send tokens to multiple addresses in a single transaction
- **Bulk ETH Transfers**: Distribute ETH to multiple recipients efficiently
- **Static Value Distribution**: Send the same amount to all recipients
- **Dynamic Value Distribution**: Send different amounts to each recipient
- **Gas Optimization**: Reduce transaction costs by batching transfers
- **Owner Controls**: Contract owner can withdraw accumulated ETH and transfer ownership

## Contract Functions

### Static Value Transfers

Send the same amount to all recipients:

```solidity
// ERC20 tokens
transferStaticValue(address _tokenAddress, address[] memory _to, uint256 _value)

// ETH
transferStaticValue(address[] memory _to, uint256 _value) payable
```

### Dynamic Value Transfers

Send different amounts to each recipient:

```solidity
// ERC20 tokens
transferDynamicValues(address _tokenAddress, address[] memory _to, uint256[] memory _values)

// ETH
transferDynamicValues(address[] memory _to, uint256[] memory _values) payable
```

## Usage Examples

### ERC20 Token Airdrop (Static Amount)

```javascript
const recipients = [
  "0x742d35Cc6634C0532925a3b8D4C9db96590c6C87",
  "0x8ba1f109551bD432803012645Hac136c22C177ec",
  "0x1234567890123456789012345678901234567890"
];

const tokenAddress = "0xYourTokenAddress";
const amountPerRecipient = ethers.utils.parseUnits("100", 18); // 100 tokens

await bulkTransfer.transferStaticValue(tokenAddress, recipients, amountPerRecipient);
```

### ETH Airdrop (Dynamic Amounts)

```javascript
const recipients = [
  "0x742d35Cc6634C0532925a3b8D4C9db96590c6C87",
  "0x8ba1f109551bD432803012645Hac136c22C177ec"
];

const amounts = [
  ethers.utils.parseEther("0.1"), // 0.1 ETH
  ethers.utils.parseEther("0.2")  // 0.2 ETH
];

const totalValue = ethers.utils.parseEther("0.3");

await bulkTransfer.transferDynamicValues(recipients, amounts, { value: totalValue });
```

## Prerequisites

- **For ERC20 transfers**: Approve the BulkTransfer contract to spend your tokens first
- **For ETH transfers**: Send sufficient ETH with the transaction to cover all transfers

## Security Features

- Input validation for all parameters
- Balance checks before transfers
- Protection against zero addresses
- Owner-only functions for contract management
- Event emission for transfer tracking

## Gas Optimization

This contract significantly reduces gas costs compared to individual transfers:
- Single transaction for multiple recipients
- Optimized loops and storage usage
- Minimal external calls

## Events

```solidity
event TokensTransferred(address indexed from, address[] indexed to, uint256 value);
```

Tracks all bulk transfers with sender, recipients, and total value.

## Owner Functions

- `transferOwnership(address newOwner)`: Transfer contract ownership
- `withdraw()`: Withdraw accumulated ETH from the contract

## Installation & Deployment

1. Install dependencies:
```bash
npm install @openzeppelin/contracts
```

2. Compile the contract:
```bash
npx hardhat compile
```

3. Deploy to your preferred network:
```bash
npx hardhat run scripts/deploy.js --network [network-name]
```

## License

MIT License - see [LICENSE](LICENSE) file for details.

## Security Considerations

- Always test on testnets before mainnet deployment
- Verify recipient addresses before bulk transfers
- Consider gas limits for large recipient lists
- Ensure sufficient token allowances for ERC20 transfers

## Contributing

Contributions are welcome! Please ensure all changes include appropriate tests and follow Solidity best practices.