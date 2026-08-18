extends Area2D

@export var amount := 25

func _on_body_entered(body):
	if body.is_in_group("player"):
		GameLogger.debug("GoldPickup", "Player entered: GoldPickup scene. RunData.add_gold() called")
		RunData.add_gold(amount)
		queue_free()

func _ready() -> void:
	GameLogger.info("GoldPickup", "GoldPickup ready")
