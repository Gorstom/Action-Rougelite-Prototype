extends Control

func _on_start_button_pressed():
	GameManager.start_run()

func _on_quit_button_pressed():
	GameManager.quit_game()
