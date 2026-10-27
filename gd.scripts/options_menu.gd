extends Control

# Kunin natin ang index ng Master audio bus
var master_bus = AudioServer.get_bus_index("Master")

func _ready() -> void:
	# Para pag-open ng Options, tugma yung slider sa current volume
	var current_vol_db = AudioServer.get_bus_volume_db(master_bus)
	$HSlider.value = db_to_linear(current_vol_db) * 100

func _on_h_slider_value_changed(value: float) -> void:
	# Volume Control (Value 0-100)
	AudioServer.set_bus_volume_db(master_bus, linear_to_db(value / 100.0))
	
	# Mute automatic pag zero
	AudioServer.set_bus_mute(master_bus, value == 0)

func _on_check_box_toggled(toggled_on: bool) -> void:
	# 1. Kunin ang index ng Master bus
	var master_bus = AudioServer.get_bus_index("Master")
	
	# 2. I-mute kung naka-check (toggled_on = true)
	AudioServer.set_bus_mute(master_bus, toggled_on)
	
	# Pang-check sa console
	if toggled_on:
		print("Muted, gago!")
	else:
		print("Music is back!")

func _on_button_pressed() -> void:
	# BACK button pabalik sa Main Menu (Path fixed: nasa labas lang)
	get_tree().change_scene_to_file("res://main_menu.tscn")
