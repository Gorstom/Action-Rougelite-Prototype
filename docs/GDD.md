## Expedition Roguelite Prototype
## 1. High Concept

A top-down action roguelite where the player enters procedurally generated dungeons, fights enemies, collects loot, and extracts back to a hub to upgrade equipment and prepare for the next expedition.

The core idea is a risk-based expedition system: the longer the player stays in the dungeon, the greater the rewards, but also the higher the risk of losing everything on death.
## 2. Genre

- Action Roguelite
- Dungeon Crawler
- Extraction-based progression game
- Top-down real-time combat
---

## 3. Core Gameplay Loop

1. Enter dungeon (expedition start)
2. Explore rooms
3. Fight enemies
4. Collect loot and currency
5. Decide to continue or extract
6. Return to hub with loot
7. Upgrade equipment and stats
8. Repeat with higher risk runs

---

## 4. Core Pillars

### 4.1 Risk vs Reward

The player constantly decides whether to:
- push deeper for better loot
- extract early to secure gains

### 4.2 Run-Based Structure

Each expedition is a self-contained run:
- procedural layout
- temporary progress during run
- permanent progression via loot and upgrades
### 4.3 Progression

Long-term growth through:
- better gear
- stat upgrades
- economy improvements

---

## 5. Gameplay Systems

### 5.1 Player System
- top-down movement (real-time)
- health system
- damage and death
- basic combat (melee or ranged)
### 5.2 Combat System
- real-time encounters
- enemy chase AI
- collision-based damage
- optional attack system (melee or projectile)
### 5.3 Enemy System
- basic AI (chase player)
- damage on contact
- future expansion: ranged and elite enemies
### 5.4 Dungeon System
- procedural room generation
- room-based progression
- exits between rooms 
- spawn-based enemies and loot
### 5.5 Loot System
- gold and materials
- equipment drops
- risk-based loot scaling (deeper = better rewards)
### 5.6 Hub System
- safe area between runs
- shop / merchant
- equipment upgrades
- preparation for next expedition
### 5.7 Economy System
- sell loot for gold
- buy upgrades and equipment
- progression balancing between runs

---

## 6. Game Modes

### Expedition Mode
Main gameplay loop inside dungeon:
- exploration
- combat
- loot collection
- extraction decisions
### Hub Mode
Meta progression layer:
- upgrades
- inventory management
- preparation

---

## 7. Win / Loss Conditions
### Loss Condition
- player dies in dungeon
- run is lost
- loot not extracted is lost

### Win Condition

No final win condition.  
The game is designed as an infinite progression loop.

---

## 8. Art Direction (Prototype Level)
- top-down 2D visuals
- placeholder sprites
- readability over detail
- functional UI focus

---

## 9. Technical Stack
- Engine: Godot 4
- Language: GDScript
- Architecture: scene-based + autoload systems
- Version control: Git    

---

## 10. Design Goals
- fast iteration prototype
- simple but expandable systems
- strong gameplay loop first, content later
- modular architecture for future scaling

---

## 11. Scope Definition
This is a prototype project focused on:
- gameplay systems
- core loop validation
- procedural dungeon experiments

Not a final commercial product.

---

## 12. Future Expansion
- item synergies
- enemy variety
- boss fights
- deeper procedural generation
- skill trees
- meta-progression systems