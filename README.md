# Type Island

## Table of Contents
1. [Overview](#Overview)
1. [Product Spec](#Product-Spec)
1. [Wireframes](#Wireframes)
2. [Schema](#Schema)

## Overview
### Description
Singleplayer speed-typing based game. Complete typing based challenges to combat monsters and unlock rewards.

### App Evaluation

- **Category:** Game
- **Mobile:** This app would work on a computer but would be a completely different experience due to the change of keyboard. 
- **Story:** The user will "battle" to earn gold to unlock features for their home island. The battle will consist of the user completing typing-related challenges to progress through an endless stream of monsters, earning more gold the longer they survive.
- **Market:** Anyone and everyone. 
- **Habit:** While it may be addictive in the short term as the user battles new monsters and unlocks new features, there will be a point at which they reach an end and there is no current reason to replay the game.
- **Scope:** We will start with a single game mode and limited features for purchase. We may add other game modes and multiplayer functionality in the future.

## Product Spec

### 1. User Stories (Required and Optional)

**Required Must-have Stories**

* User views tutorial on first launch
* User can access settings and stats
* User can purchase new features for their island from the shop
* User can battle monsters via challenges for gold
* By successfully completing a challenge, the user damages the monster. If the user fails, they take damage.
* Challenges get increasingly harder over time, with monsters rewarding more gold as well.
* Upon death gold is rewarded and they return to their hub
* Gold, unlocks, stats, and settings are saved across restarts


**Optional Nice-to-have Stories**

* Certain words may be in a different text color and will act as powerups if typed correctly
* Multiply damage done if user has a combo going, which will be based on their speed and accuracy
* animation for attacking

### 2. Screen Archetypes

* Home/Hub
   * Buttons to access the settings and shop, as well as go to battle.
   * Pop up menus for the settings and shop.
   * Label indicating the user's total in-game currency.
* Battle Screen (the actual game)
   * Allows the user to complete typing-based challenges to progress through the level and earn in-game currency.
   * Get progressively harder over time.
   * User has three lives which are lost when they fail a challenge.

### 3. Navigation

**Tab Navigation** (Tab to Screen)

* N/A

**Flow Navigation** (Screen to Screen)

* 'Adventure' button -> Battle screen
* 'Complete Adventure' button -> Home/Hub Screen


## Wireframes
<img src="https://user-images.githubusercontent.com/86101798/161202931-18f6d66b-255c-4371-89ed-f617c3255fdd.jpg" width=600>

### [BONUS] Digital Wireframes & Mockups

### [BONUS] Interactive Prototype

## Schema 

### Models

<img width="990" alt="image" src="https://user-images.githubusercontent.com/86101798/161360786-6ac0ff33-59ec-482d-a158-c431c1f1c221.png">

### Networking
* Home Screen
   *(Update/PUT) Update user in game currency
   *(Update/PUT) Update user unlocked rewards
   *(Update/PUT) Update user settings
* Battle Screen
   *(Update/PUT) Update user in game currency
   *(Update/PUT) Update user statistics
