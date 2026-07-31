extends Area2D

@export var reward_item: ItemData
var opened := false


func _on_body_entered(body):
	if opened:
		return
	
	if body.is_in_group("player"):
		open()


func open():
	# another layer of bug prevention
	if opened:
		return
	
	opened = true
	var gold = 100
	RunData.add_gold(gold)
	
	if reward_item:
		RunData.add_item(reward_item)
		GameLogger.info("Chest", "Added item: %s" % reward_item.name)
	
	GameLogger.info("Chest", "Chest opened: + %d gold" % gold)

func _ready():
	GameLogger.debug("Chest", "Chest ready")
