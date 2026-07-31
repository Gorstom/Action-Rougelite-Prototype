extends Node

var gold := 0
var inventory: Array[ItemData] = []

var max_hp := 100
var damage := 25


func add_gold(amount: int):
	gold += amount


func add_item(item):
	inventory.append(item)
	GameLogger.debug("RunData", RunData.inventory)

func reset():
	gold = 0
	inventory.clear()
	max_hp = 100
	damage = 25
