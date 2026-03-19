# AI Task: Monetization System

## Task ID
AI-TASK-001

## Objective
Implement a complete monetization system including virtual currency, shop system, and in-app purchase integration.

## Input
- Flutter project source code
- game_shop_page.dart
- Firebase Firestore: `ecoco-game-db` (Currently empty, needs schema setup)
- Firebase Cloud Functions: (Currently waiting for first deployment)

## Expected Output
- Dynamic shop system
- Virtual currency balance system
- In-app purchase integration
- Receipt validation implementation

## Dependencies
- Flutter
- in_app_purchase package
- firebase_core & cloud_firestore
- firebase_functions (for receipt validation API)

## Execution Steps

1. Install required package
   - Add `in_app_purchase` dependency

2. Refactor Shop UI
   - Convert static UI to dynamic product list
   - Create product model

3. Implement Virtual Currency System
   - Define currency schema
   - Implement balance state management

4. Implement Purchase Flow
   - Load store products
   - Handle purchase request
   - Process purchase updates

5. Implement Receipt Validation (Cloud Functions)
   - Write and deploy first Cloud Function for receipt validation
   - Validate transaction result securely on the server

6. Implement Balance Synchronization (Firestore)
   - Initialize player wallet document in `ecoco-game-db`
   - Sync balance with server securely via Cloud Functions
   - Prevent client-side modification

## Deliverables
- Updated shop UI
- Purchase handler
- Currency management logic
- Receipt validation integration