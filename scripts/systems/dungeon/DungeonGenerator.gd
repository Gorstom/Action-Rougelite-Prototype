extends Node
class_name DungeonGenerator

var dungeon_rooms: Array[RoomNode] = []
var occupied_positions: Array[Vector2i] = []

var directions = [
	Vector2i.UP,
	Vector2i.DOWN,
	Vector2i.LEFT,
	Vector2i.RIGHT
]


func generate(room_count: int):
	occupied_positions.clear()
	dungeon_rooms.clear()

	var start = RoomNode.new(Vector2i.ZERO)
	start.type = RoomNode.RoomType.START
	
	dungeon_rooms.append(start)
	occupied_positions.append(start.position)

	var current = start

	for i in range(room_count - 1):
		var direction
		var new_position

		while true:
			direction = directions.pick_random()
			new_position = current.position + direction
			
			if not occupied_positions.has(new_position):
				break
		
		var room = RoomNode.new(new_position)
		
		current.neighbors.append(room)
		room.neighbors.append(current)
		
		dungeon_rooms.append(room)
		occupied_positions.append(new_position)
		current = room

	return dungeon_rooms
