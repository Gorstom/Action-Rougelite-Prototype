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
# var room_index := 0

var dungeon: Array[RoomNode] = []
var current_room_node: RoomNode


func create_dungeon():
	var generator = DungeonGenerator.new()
	dungeon = generator.generate(10)
	current_room_node = dungeon[0]

	GameLogger.info("RoomManager", "Dungeon generated")

	for room in dungeon:
		GameLogger.debug("RoomManager", str(room.position))
	
	test_navigation()
	
func start_run():
	create_dungeon()
	start_room()

func start_room(entry_direction = null):
	state = RoomState.ACTIVE
	# room_index += 1
	
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

	var next_room = move_to_next_room(direction)
	
	if next_room == null:
		GameLogger.info("RoomManager", "No room in this direction")
		return
		
	call_deferred("load_next_room", direction)

func pick_room_for_entry(direction: String) -> PackedScene:
	var possible_rooms = []

	for room_scene in rooms:
		var room = room_scene.instantiate()

		if direction in room.available_exits:
			possible_rooms.append(room_scene)

		room.queue_free()

	if possible_rooms.is_empty():
		return null

	return possible_rooms.pick_random()

func load_next_room(direction):
	if current_room:
		current_room.queue_free()
		
	var next_room_scene = pick_room_for_entry(opposite_direction(direction))
	
	current_room = next_room_scene.instantiate()
	
	room_container.add_child(current_room)
	current_room.room_exit.connect(_on_room_exit)

	spawn_points = current_room.get_node("SpawnPoints").get_children()
	current_room.spawn_player_at(opposite_direction(direction))
	current_room.lock_doors(true)

	enemies_alive = 0
	spawn_room()

	GameLogger.info("RoomManager", "Moved to room: %s" % current_room_node.position)

func spawn_room():
	enemies_alive = 0
	var enemy_count = randi_range(2, 5)
	
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
	chest.global_position = reward_position.global_position
	
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

# helper function for navigating graph 
func get_room_at(position: Vector2i) -> RoomNode:
	for room in dungeon:
		if room.position == position:
			return room
	
	return null

func move_to_next_room(direction):
	var next_position = current_room_node.position
	
	
	match direction:
		RoomNode.Direction.LEFT:
			next_position.x -= 1
		RoomNode.Direction.RIGHT:
			next_position.x += 1
		RoomNode.Direction.DOWN:
			next_position.y -= 1
		RoomNode.Direction.UP:
			next_position.y += 1
	
	var next_room = get_room_at(next_position)
	
	if next_room != null:
		current_room_node = next_room
		return current_room_node

func test_navigation():
	GameLogger.debug("RoomManager", "Current: %s" % current_room_node.position)

	var next = move_to_next_room(RoomNode.Direction.RIGHT)

	if next:
		GameLogger.debug("RoomManager", "Moved to: %s" % current_room_node.position)
	else:
		GameLogger.debug("RoomManager", "No room there")

func opposite_direction(direction: String) -> String:
	match direction:
		"LEFT":
			return "RIGHT"
		"RIGHT":
			return "LEFT"
		"UP":
			return "DOWN"
		"DOWN":
			return "UP"

	return direction
