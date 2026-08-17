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
	
	#test_navigation()
	
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

func get_required_exits(room_node: RoomNode) -> Array[String]:
	var exits: Array[String] = []

	for neighbor in room_node.neighbors:
		var diff = neighbor.position - room_node.position

		if diff == Vector2i.LEFT:
			exits.append("LEFT")
		elif diff == Vector2i.RIGHT:
			exits.append("RIGHT")
		elif diff == Vector2i.UP:
			exits.append("UP")
		elif diff == Vector2i.DOWN:
			exits.append("DOWN")

	return exits

func load_room(direction = null):
	state = RoomState.ACTIVE

	if current_room:
		current_room.queue_free()
	
	GameLogger.debug(
	"RoomManager",
	"Entering graph node: %s" % current_room_node.position
	)
	
	var next_room = pick_room_for_node(current_room_node)
	
	if next_room == null:
		return

	current_room = next_room.instantiate()
	room_container.add_child(current_room)
	
	current_room.room_exit.connect(_on_room_exit)

	spawn_points = current_room.get_node("SpawnPoints").get_children()
	
	if direction:
		current_room.spawn_player_at(direction)
		
func _on_room_exit(direction):
	GameLogger.info("RoomManager", "Exit direction: %s" % direction)

	if state != RoomState.CLEANED:
		return

	var next_room = move_to_next_room(direction)
	
	if next_room == null:
		GameLogger.info("RoomManager", "No room in this direction")
		return
		
	call_deferred("load_next_room", direction)

#func pick_room_for_entry(direction: String) -> PackedScene:
	#var possible_rooms = []
#
	#for room_scene in rooms:
		#var room = room_scene.instantiate()
#
		#if direction in room.available_exits:
			#possible_rooms.append(room_scene)
#
		#room.queue_free()
#
	#if possible_rooms.is_empty():
		#return null
#
	#return possible_rooms.pick_random()

func pick_room_for_node(room_node: RoomNode) -> PackedScene:
	var required_exits = get_required_exits(room_node)
	GameLogger.debug(
		"RoomManager",
		"Required exits: " + str(required_exits)
	)
	var possible_rooms: Array[PackedScene] = []

	for room_scene in rooms:
		GameLogger.debug(
			"RoomManager",
			"Checking scene: " + room_scene.resource_path
		)
		var room = room_scene.instantiate()
	
		GameLogger.debug(
			"RoomManager",
			"Scene exits: " + str(room.get_exits())
		)

		if room.has_exact_exits(required_exits):
			GameLogger.debug(
				"RoomManager",
				"FOUND: " + str(room_scene.resource_path)
			)

			possible_rooms.append(room_scene)

		room.queue_free()

	if possible_rooms.is_empty():
		GameLogger.error(
			"RoomManager",
			"No room found for exits: " + str(required_exits)
		)
		return null

	return possible_rooms.pick_random()

func load_next_room(direction):
	state = RoomState.ACTIVE
	if current_room:
		current_room.queue_free()
	
	var next_room_scene = pick_room_for_node(current_room_node)
	
	if next_room_scene == null:
		return
	
	current_room = next_room_scene.instantiate()
	room_container.add_child(current_room)
	
	current_room.room_exit.connect(_on_room_exit)

	spawn_points = current_room.get_node("SpawnPoints").get_children()
	current_room.spawn_player_at(opposite_direction(direction))
	current_room.lock_doors(true)

	enemies_alive = 0
	GameLogger.debug(
	"RoomManager",
	"Current graph room: %s" % current_room_node.position
)
	spawn_room()

	GameLogger.info("RoomManager", "Moved to room: %s" % current_room_node.position)

func spawn_room():
	enemies_alive = 0
	var enemy_count = randi_range(2, 5)
	
	for i in range(enemy_count):
		var enemy = enemy_scene.instantiate()
		
		current_room.get_node("Enemies").add_child(enemy)
		var spawn = spawn_points[i % spawn_points.size()]
		enemy.global_position = spawn.global_position + Vector2(randf_range(-10,10), randf_range(-10,10))
		
		enemy.died.connect(_on_enemy_killed)
		
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
	GameLogger.debug(
		"RoomManager",
		"Enemies left: %d State: %d" % [enemies_alive, state]
	)

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
	GameLogger.debug(
		"RoomManager",
		"Moving from %s direction=%s" % [
			current_room_node.position,
			direction
		]
	)
	
	var next_position = current_room_node.position
	
	
	match direction:
		"LEFT":
			next_position.x -= 1
		"RIGHT":
			next_position.x += 1
		"DOWN":
			next_position.y += 1
		"UP":
			next_position.y -= 1
	
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
