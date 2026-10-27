extends Control

# Eto ang gagamitin mo para sa "PLAY AGAIN" button
func _on_play_again_button_pressed() -> void:
	# Siguraduhin na "main_menu.tscn" ang pangalan ng file mo, ha!
	get_tree().change_scene_to_file("res://main_menu.tscn") 

# Eto naman para sa "QUIT" button kung meron ka
func _on_quit_button_pressed() -> void:
	get_tree().quit()


func _on_button_pressed() -> void:
	pass # Replace with function body.
