extends Node2D

@onready var player = $Player
@onready var health_bar = $CanvasLayer/HealthBar
@onready var room_manager = $RoomManager

func _ready():
	health_bar.max_value = player.max_hp
	health_bar.value = player.hp
	
	player.hp_changed.connect(_on_hp_changed)
	
	print("MAX HP:", player.max_hp)
	print("HP:", player.hp)
	
	room_manager.room_cleared.connect(_on_room_cleared)
	room_manager.start_room()

func _on_room_cleared():
	print("ROOM CLEARED")
	await get_tree().create_timer(1.0).timeout
	room_manager.start_room()

func _on_hp_changed(current, max):
	health_bar.value = current
