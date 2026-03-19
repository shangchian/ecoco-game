# AI Task: Gameplay & Collection System

## Task ID
AI-TASK-002

## Objective
Implement battle engine, item drop system, and persistent inventory.

## Input
- Flutter game UI
- battle_screen.dart
- inventory UI

## Expected Output
- Battle engine
- Damage calculation system
- Item drop system
- Inventory persistence

## Dependencies
- Flutter
- Local storage (Hive or SharedPreferences)
- Firebase Firestore (Optional for cloud save: `ecoco-game-db`)

## Execution Steps

1. Implement Battle Engine
   - Define battle state
   - Implement turn-based attack logic
   - Implement damage formula

2. Implement EXP System
   - Define EXP gain logic
   - Implement level-up calculation

3. Implement Item Schema
   - Define item model
   - Define item types (equipment, consumable)

4. Implement Drop System
   - Define drop table
   - Implement random drop logic

5. Implement Inventory System
   - Create inventory data structure
   - Implement add/remove item logic

6. Implement Data Persistence
   - Save inventory locally
   - Load player inventory on startup
   - (Optional) Sync inventory data to Firestore `ecoco-game-db` for cloud backup

7. Optimize Asset Loading
   - Convert images to WebP
   - Implement lazy loading
   - Implement memory cache

## Deliverables
- Battle engine logic
- Item system
- Inventory persistence
- Optimized asset loading