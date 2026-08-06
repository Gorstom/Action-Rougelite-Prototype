class_name RoomNode

enum Direction {
	LEFT,
	RIGHT,
	UP,
	DOWN
}

enum RoomType {
	START,
	COMBAT,
	TREASURE,
	BOSS,
	EXIT
}

var position: Vector2i
var type: RoomType
var neighbors: Array[RoomNode] = []


func _init(pos: Vector2i):
	position = pos
