extends Area2D

var opened := false


func _on_body_entered(body):
	if opened:
		return
	
	if body.is_in_group("player"):
		open()


func open():
	opened = true
	var gold = 100
	RunData.add_gold(gold)
	GameLogger.info("Chest", "Chest opened: + %d gold" % gold)
