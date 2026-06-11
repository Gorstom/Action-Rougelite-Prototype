extends Node2D

@onready var player = $Player
@onready var health_bar = $CanvasLayer/HealthBar

func _ready():
	health_bar.max_value = player.max_hp
	health_bar.value = player.hp
	
	player.hp_changed.connect(_on_hp_changed)
	
	print("MAX HP:", player.max_hp)
	print("HP:", player.hp)
		
func _on_hp_changed(current, max):
	health_bar.value = current
