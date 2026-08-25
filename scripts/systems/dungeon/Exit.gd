extends Area2D

func interact():
	GameLogger.debug("Exit", "Exit activated - returning to hub")
	GameManager.return_to_hub()
