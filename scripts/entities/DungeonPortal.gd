extends Area2D

func interact():
	GameLogger.debug("DungeonPortal", "Interact button pressed - starting dungeon run")
	GameManager.start_run()

func _on_body_entered(body):
	if body.is_in_group("player"):
		GameLogger.debug("DungeonPortal", "Player entered: DungeonPortal hitbox")
