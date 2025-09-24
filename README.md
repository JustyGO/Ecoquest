# EcoTracker: Decentralized Environmental Impact Tracking

A blockchain-based smart contract system built on the Stacks blockchain for tracking and rewarding eco-friendly actions. EcoTracker enables users to log their environmental activities and earn points for sustainable behaviors.

## 🌱 Overview

EcoTracker is a decentralized application that incentivizes environmental consciousness by allowing users to:
- Track their eco-friendly activities on the blockchain
- Earn green points for sustainable actions
- Build a verifiable environmental impact profile
- Participate in a community-driven sustainability network

## 📋 Features

### Core Functionality
- **Member Registration**: Join the eco-network and create your environmental profile
- **Action Logging**: Record recycling, energy-saving, and tree-planting activities
- **Point System**: Earn rewards for each eco-friendly action
- **Impact Tracking**: Monitor your cumulative environmental impact score
- **Time Decay**: Scores naturally decay over time to encourage consistent activity

### Supported Eco Actions
| Action | Default Points | Description |
|--------|---------------|-------------|
| Recycling | 10 points | Log recycling activities |
| Energy Saving | 5 points | Track energy conservation efforts |
| Tree Planting | 15 points | Record tree planting activities |

## 🚀 Getting Started

### Prerequisites
- Stacks wallet (e.g., Hiro Wallet, Xverse)
- STX tokens for transaction fees
- Access to a Stacks blockchain node or web interface

### Deployment
1. Deploy the smart contract to the Stacks blockchain
2. The deploying address becomes the eco-admin
3. Default reward points are automatically set for all actions

## 📖 Usage

### For Members

#### 1. Join the Network
```clarity
(contract-call? .ecotracker join-eco-network)
```

#### 2. Log Your Activities
```clarity
;; Log recycling activity
(contract-call? .ecotracker log-recycling)

;; Log energy saving activity
(contract-call? .ecotracker log-energy-save)

;; Log tree planting activity
(contract-call? .ecotracker log-tree-planting)
```

#### 3. Check Your Impact
```clarity
;; Get your full profile
(contract-call? .ecotracker get-member-impact 'YOUR-ADDRESS)

;; Get current impact with time decay applied
(contract-call? .ecotracker get-current-impact 'YOUR-ADDRESS)
```

### For Administrators

#### Update Reward Points
```clarity
(contract-call? .ecotracker update-eco-reward "recycling" u15)
```

## 📊 Data Structure

### Member Profile
Each member's environmental impact is tracked with:
- `green-score`: Total points earned
- `recycling-acts`: Number of recycling activities
- `energy-saves`: Number of energy-saving activities  
- `tree-plants`: Number of trees planted
- `last-activity`: Block height of last recorded activity

### Reward System
- Points are awarded immediately upon logging activities
- Maximum reward per action: 1,000 points
- Time decay encourages regular participation

## 🔒 Security Features

- **Access Control**: Only registered members can log activities
- **Admin Privileges**: Only contract deployer can modify reward points
- **Input Validation**: All actions are validated against approved eco-actions list
- **Error Handling**: Comprehensive error codes for debugging

## 🎯 Error Codes

| Code | Constant | Description |
|------|----------|-------------|
| u100 | err-admin-only | Action requires admin privileges |
| u101 | err-member-missing | Member profile not found |
| u102 | err-access-denied | Access denied |
| u103 | err-member-exists | Member already registered |
| u104 | err-no-profile | No member profile exists |
| u105 | err-invalid-action | Invalid eco action type |
| u106 | err-bad-input | Invalid input parameters |

## 🔍 Read-Only Functions

### `get-member-impact`
Retrieve a member's complete environmental profile.

### `get-action-points`
Get the current point value for a specific eco action.

### `get-current-impact`
Calculate current impact score with time decay applied.

## ⚙️ Technical Details

### Built With
- **Clarity**: Smart contract language for Stacks blockchain
- **Stacks Blockchain**: Layer-1 blockchain secured by Bitcoin

### Contract Architecture
- Modular function design
- Efficient data storage using maps
- Gas-optimized operations
- Future-proof extensibility

## 🌍 Environmental Impact

EcoTracker promotes environmental awareness by:
- Gamifying sustainable behaviors
- Creating transparent impact tracking
- Building community around eco-consciousness
- Providing verifiable proof of environmental actions
