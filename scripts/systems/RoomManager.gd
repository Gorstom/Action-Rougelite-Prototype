extends Node

@export var enemy_scene: PackedScene
@export var rooms: Array[PackedScene]
@export var chest_scene: PackedScene

@onready var room_container = $"../World/RoomContainer"

var enemies_alive := 0
var wave := 0
var spawn_points

var current_room

signal room_cleared

enum RoomState {
	ACTIVE,
	CLEANED,
	TRANSITION
}

var state := RoomState.ACTIVE
var room_index := 0

func start_room(entry_direction = null):
	state = RoomState.ACTIVE
	room_index += 1
	
	load_room(entry_direction)
	
	if current_room == null:
		return

	current_room.lock_doors(true)
	
	GameLogger.info("RoomManager", "Room started")
	spawn_room()
	
func load_room(entry_direction = null):
	if current_room:
		current_room.queue_free()
	
	var next_room = rooms.pick_random()
	current_room = next_room.instantiate()
	room_container.add_child(current_room)
	
	current_room.room_exit.connect(_on_room_exit)

	spawn_points = current_room.get_node("SpawnPoints").get_children()
	
	if entry_direction:
		current_room.spawn_player_at(entry_direction)
		
func _on_room_exit(direction):
	GameLogger.info("RoomManager", "Exit direction: %s" % direction)

	if state != RoomState.CLEANED:
		return

	call_deferred("start_room")

func spawn_room():
	enemies_alive = 0
	var enemy_count = room_index
	
	for i in range(enemy_count):
		var enemy = enemy_scene.instantiate()
		
		var spawn = spawn_points[i % spawn_points.size()]
		enemy.global_position = spawn.global_position
		
		enemy.died.connect(_on_enemy_killed)
		
		current_room.get_node("Enemies").add_child(enemy)
		enemies_alive += 1
	
	GameLogger.info("RoomManager", "Room spawned")
	
# old wave system	
#func spawn_wave(count: int):
	#enemies_alive = 0
#
	#for i in range(count):
		#var enemy = enemy_scene.instantiate()
#
		#var spawn = spawn_points[i % spawn_points.size()]
		#enemy.global_position = spawn.global_position
#
		#enemy.died.connect(_on_enemy_killed)
#
		#get_node("../Enemies").add_child(enemy)
		#enemies_alive += 1
	#print("WAVE SPWANED")

func spawn_reward():
	var chest = chest_scene.instantiate()
	var reward_position = current_room.get_node("RewardPoint")
	chest.global_position = current_room.global_position
	
	current_room.add_child(chest)
	
	GameLogger.info("RoomManager", "Reward spawned")

func _on_enemy_killed():
	enemies_alive -= 1
	GameLogger.info("RoomManager", "Enemy killed")

	if enemies_alive <= 0 and state == RoomState.ACTIVE:
		state = RoomState.CLEANED
		
		spawn_reward()
		current_room.lock_doors(false)
		
		GameLogger.info("RoomManager", "Room cleaned")
		room_cleared.emit()
