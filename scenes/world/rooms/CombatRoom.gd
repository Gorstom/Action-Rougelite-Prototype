extends Node2D

@onready var doors = $Doors.get_children()
#@export var available_exits: Array[String]
#
#var exits: Array[String] = []

signal room_exit(direction: String)


func _ready():
	for door in doors:
		door.door_entered.connect(_on_door_entered)
		
	#GameLogger.debug(
	#"CombatRoom",
	#"Available exits: %s | Actual exits: %s" % [
		#available_exits,
		#exits
	#])
	
	GameLogger.debug("CombatRoom", "Combat room ready")

func get_exits() -> Array[String]:
	var result: Array[String] = []

	for door in $Doors.get_children():
		result.append(door.direction)

	return result
	
#func has_exit(direction: String) -> bool:
	#return direction in exits

func has_exact_exits(required_exits: Array[String]) -> bool:
	var actual_exits = get_exits()
	
	if actual_exits.size() != required_exits.size():
		return false

	for exit in required_exits:
		if exit not in actual_exits:
			return false

	return true

func _on_door_entered(direction):
	room_exit.emit(direction)


func lock_doors(value: bool):
	for door in doors:
		door.set_locked(value)

func spawn_player_at(direction: String):
	var player = get_tree().get_first_node_in_group("player")

	if player == null:
		return

	var spawn = $PlayerSpawns.get_node(direction)
	player.global_position = spawn.global_position
