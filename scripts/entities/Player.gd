extends CharacterBody2D


@export var speed := 200.0
@export var max_hp := 100
@export var attack_damage := 25
@export var attack_range := 50.0
@export var attack_cooldown := 0.4
var can_attack := true

signal hp_changed(current, max)

var hp := max_hp

func take_damage(amount: int):
	hp -= amount
	hp_changed.emit(hp, max_hp)
	
	print("PLAYER HP: ", hp)
	
	if hp <= 0:
		die()

func die():
	print("PLAYER DIED")
	GameManager.return_to_hub()

func _physics_process(delta):
	var input_dir = Vector2.ZERO

	input_dir.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_dir.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")

	input_dir = input_dir.normalized()

	velocity = input_dir * speed
	move_and_slide()
	
	if Input.is_action_just_pressed("attack"):
		attack()

func attack():
	if not can_attack:
		return
	
	can_attack = false
	
	var enemies = get_tree().get_nodes_in_group("enemy")

	for enemy in enemies:
		if global_position.distance_to(enemy.global_position) <= attack_range:
			enemy.take_damage(attack_damage)
	
	await get_tree().create_timer(attack_cooldown).timeout
	can_attack = true
	
func _ready() -> void:
	hp = max_hp
	print("PLAYER READY")
