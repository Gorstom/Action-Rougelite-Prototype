extends Node2D

@onready var doors = $Doors.get_children()

var exits: Array[String] = []

signal room_exit(direction: String)


func _ready():
	for door in doors:
		exits.append(door.direction)
		door.door_entered.connect(_on_door_entered)

func has_exit(direction: String) -> bool:
	return direction in exits


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
