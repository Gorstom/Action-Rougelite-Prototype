extends Area2D

var locked := true

signal door_entered
@export_enum("LEFT", "RIGHT", "UP", "DOWN") var direction: String

func set_locked(value: bool):
	locked = value
	visible = !value

func _on_body_entered(body):
	GameLogger.debug("Door", "Body entered: %s" % body.name)
	
	if locked:
		return

	if body.is_in_group("player"):
		GameLogger.debug("Door", "Hit")
		GameLogger.info("Door", "Player entered door: %s" % direction)
		door_entered.emit(direction)

func _ready():
	body_entered.connect(_on_body_entered)
	GameLogger.debug("Door", "Door ready")
	
# debug
#func _physics_process(delta):
	#for body in get_overlapping_bodies():
		#print("OVERLAP:", body.name)
