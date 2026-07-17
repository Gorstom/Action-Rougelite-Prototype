extends Node2D

@onready var doors = $Doors.get_children()

signal room_exit


func _ready():
	for door in doors:
		door.door_entered.connect(_on_door_entered)


func _on_door_entered():
	room_exit.emit()


func lock_doors(value: bool):
	for door in doors:
		door.set_locked(value)
