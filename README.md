# Action Roguelite Prototype

Top-down action roguelite prototype made in Godot 4.7 using GDScript. Focuses on procedural dungeon generation, basic combat systems, enemy AI, gameplay architecture experiments and exploring engine capabilities and its design philosophy. 

## Project status

Currently project is nearing completion. The remaining work focuses on 
finishing the core extraction loop, with possible additional tweaking with progression system design and implementation. Further development (at least for now) beyond current scope is not planned.

## Possible future features
- basic progression system

### Implemented
- enemy AI (basic chase)
- combat system
- loot system
- loot drops system
- top-down movement
- simple game loop (death → restart)
- procedural dungeon generation

### In progress
- extraction system

## Goal of this project
The project is used to experiment with:
- procedural dungeon generation
- scene-based architecture
- event-driven design 
- collision and interaction systems
- game state and run data management
- loot and broadly understood reward systems
- basic roguelite gameplay loops

Feel free to reuse any of the code snippets, or even entire systems, if they are usefeul to you.

## Technical details
- Engine: Godot 4.7
- Language: GDScript
- Development platform: Arch Linux
- Renderer: Forward+ (Vulkan)

## Requirements
- Godot 4.7
- Vulkan-compatible GPU
