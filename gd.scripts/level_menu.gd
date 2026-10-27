extends Control

# Level 1 Button
func _on_level_1_button_pressed() -> void:
	get_tree().paused = false # Siguradong tatakbo ang laro
	get_tree().change_scene_to_file("res://main.tscn")

# Level 2 Button (Connect mo rin 'to!)
func _on_level_1_button_2_pressed() -> void: # Check mo kung anong name ang lalabas sa signal
	get_tree().paused = false
	get_tree().change_scene_to_file("res://level_2.tscn")

# Level 3 Button (Connect mo rin 'to!)
func _on_level_1_button_3_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://boss_fire.tscn")

# BACK Button (Yung pang-apat na box)
func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://main_menu.tscn")
