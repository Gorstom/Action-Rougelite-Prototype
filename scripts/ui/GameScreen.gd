extends Node2D

@onready var player = $Player
@onready var health_bar = $CanvasLayer/HealthBar
@onready var room_manager = $RoomManager

func _ready():
	health_bar.max_value = player.max_hp
	health_bar.value = player.hp
	
	player.hp_changed.connect(_on_hp_changed)
	
	GameLogger.debug("GameScreen", "Player initialized - HP: %d/%d" % [
		player.hp,
		player.max_hp
	])
	
	
	room_manager.room_cleared.connect(_on_room_cleared)
	room_manager.start_run()
	
func _on_door_entered():
	if room_manager.state != room_manager.RoomState.CLEANED:
		return

	_next_room()

func _on_room_cleared():
	GameLogger.info("GameScreen", "Room cleared")
	room_manager.state = room_manager.RoomState.CLEANED
	
	if get_tree() == null:
		return
	
	if !is_inside_tree():
		return

func _next_room():
	room_manager.state = room_manager.RoomState.ACTIVE
	get_tree().call_group("enemy", "queue_free")
	room_manager.start_room()


func _on_hp_changed(current, max):
	health_bar.value = current
