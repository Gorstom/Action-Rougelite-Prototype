extends Node

enum GameState { MENU, RUN, PAUSE, HUB, DEATH }

var state = GameState.MENU

func start_run():
	state = GameState.RUN
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/main/GameScreen.tscn")

func return_to_hub():
	#state = GameState.HUB
	#get_tree().paused = false
	#get_tree().change_scene_to_file("res://scenes/main/Hub.tscn")
	
	#put a placeholder while hud does not exist 
	print("RETURNING TO HUB")
	restart_run()

func on_player_died():
	state = GameState.DEATH
	get_tree().paused = true
	
	# prevent enemy outlives gamescene after player death
	get_tree().call_group("enemy", "set_physics_process", false)
	print("PLAYER DIED")

func restart_run():
	get_tree().paused = false
	
	get_tree().call_group("enemy", "queue_free")
	await get_tree().process_frame
	
	start_run()

func quit_game():
	print("GAME EXITED")
	get_tree().quit()

func _ready():
	print("GAMEMANAGER READY")


func _handle_esc():
	if state == GameState.RUN:
		get_tree().paused = !get_tree().paused
		state = GameState.PAUSE
	
	elif state == GameState.PAUSE:
		get_tree().paused = false
		state = GameState.RUN
	
	elif state == GameState.DEATH:
		restart_run()

	else:
		quit_game()

func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		print("ESCAPE PRESSED")
		_handle_esc()
