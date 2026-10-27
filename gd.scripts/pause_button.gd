extends Button # DAPAT BUTTON ITO, HINDI CANVASLAYER!

func _on_pressed() -> void:
	if get_tree().paused == false:
		get_tree().paused = true
		text = "PLAY"  # Tinanggal natin yung 'btn.'
		print("Naka-Pause na, gago!")
	else:
		get_tree().paused = false
		text = "PAUSE" # Tinanggal natin yung 'btn.'
		print("Laro na ulit!")
