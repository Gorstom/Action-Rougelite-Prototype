extends Node2D

@onready var player = $Player
@onready var health_bar = $CanvasLayer/HealthBar
@onready var room_manager = $RoomManager
@onready var doors = $Doors.get_children()

func _ready():
	health_bar.max_value = player.max_hp
	health_bar.value = player.hp
	
	player.hp_changed.connect(_on_hp_changed)
	
	print("MAX HP:", player.max_hp)
	print("HP:", player.hp)
	
	for door in doors:
		door.door_entered.connect(_on_door_entered)
	
	room_manager.room_cleared.connect(_on_room_cleared)
	room_manager.start_room()
	
func _on_door_entered():
	if room_manager.state != room_manager.RoomState.CLEANED:
		return

	_next_room()

func _on_room_cleared():
	print("ROOM CLEARED")
	room_manager.state = room_manager.RoomState.CLEANED
	_lock_doors(false)
	
	if get_tree() == null:
		return
	
	if !is_inside_tree():
		return

func _next_room():
	room_manager.state = room_manager.RoomState.ACTIVE
	_lock_doors(true)
	get_tree().call_group("enemy", "queue_free")
	room_manager.start_room()

func _lock_doors(value: bool):
	for door in doors:
		door.set_locked(value)


func _on_hp_changed(current, max):
	health_bar.value = current
