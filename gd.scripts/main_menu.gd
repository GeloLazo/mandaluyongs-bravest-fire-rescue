extends Control

func _on_start_pressed() -> void:
	print("START PININDOT!") # Para makita natin sa Output kung gumagana
	var error = get_tree().change_scene_to_file("res://intro_cut_scene.tscn")
	
	if error != OK:
		print("Gago, mali ang path! Error code: ", error)

func _on_options_pressed() -> void:
	print("OPTIONS PININDOT!")
	get_tree().change_scene_to_file("res://options_menu.tscn")

func _on_exit_pressed() -> void:
	# Ito ang command para isara ang laro
	get_tree().quit()

# BURAHIN MO NA YUNG _on_start_menu_pressed() KUNG WALA NAMAN LAMAN


func _on_start_menu_pressed() -> void:
	pass # Replace with function body.


func _on_level_button_pressed() -> void:
	# Siguraduhin na 'level_menu.tscn' o 'level_menuu.tscn' ang file name mo!
	get_tree().change_scene_to_file("res://level_menu.tscn")
