extends CharacterBody2D

@export var speed := 80.0
@export var damage := 10
@export var attack_cooldown := 1.0

var can_attack := true

var player: Node2D

@export var max_hp := 50
var hp := 50
var knockback_velocity := Vector2.ZERO

func _ready():
	player = get_tree().get_first_node_in_group("player")
	hp = max_hp

func _physics_process(delta):
	if player == null:
		return

	var direction = (player.global_position - global_position).normalized()
	velocity = direction * speed + knockback_velocity
	
	move_and_slide()
	
	knockback_velocity = knockback_velocity.move_toward(Vector2.ZERO, 500 * delta)
	
	for i in range(get_slide_collision_count()):
		var collision = get_slide_collision(i)

		if collision.get_collider().is_in_group("player"):
			attack(collision.get_collider())

func attack(target):
	if not can_attack:
		return

	if not is_inside_tree():
		return
	
	if get_tree() == null:
		return
		
	can_attack = false
	target.take_damage(damage)
	
	var tree = get_tree()
	if tree == null:
		return
	
	var timer = get_tree().create_timer(attack_cooldown)
	await timer.timeout
	
	if not is_inside_tree():
		return
		
	can_attack = true

func take_damage(amount):
	hp -= amount
	print("ENEMY HAS TAKEN DAMAGE: ", amount)
	
	# visual feedback
	var knockback = (global_position - player.global_position).normalized()
	knockback_velocity += knockback * 150
	
	modulate = Color.RED
	await get_tree().create_timer(0.1).timeout
	modulate = Color.WHITE
	
	if hp <= 0:
		die()

func die():
	queue_free()
