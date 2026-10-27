extends Node

# Siguraduhin na ang path na ito ay sakto sa Scene Tree mo, gago!
@onready var level_label = $CanvasLayer2/Levellabel

func _ready():
	# Bibilang sa start
	await get_tree().process_frame
	var initial_count = get_tree().get_nodes_in_group("mga_apoy").size()
	print("--- GAME START! ---")
	
	# Unang display sa screen
	if level_label:
		level_label.text = "Natitirang apoy: " + str(initial_count)

func _process(_delta):
	# Update real-time ang bilang sa screen
	var current_count = get_tree().get_nodes_in_group("mga_apoy").size()
	
	if level_label:
		if current_count > 0:
			level_label.text = "Natitirang apoy: " + str(current_count)
			level_label.modulate = Color.WHITE # Normal na kulay habang may apoy pa
		else:
			# HETO YUNG GUSTO MO: Lalabas sa gameplay screen pag tapos na
			level_label.text = "LEVEL CLEAR!\nYou can go to the next level!"
			level_label.modulate = Color.GREEN # Gawin nating Green para ramdam ang panalo

# Heto ang lipat-level logic pag tumapak sa Finish Line
func _on_finish_line_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		var current_count = get_tree().get_nodes_in_group("mga_apoy").size()
		
		if current_count == 0:
			print("LIPAT NA SA LEVEL 2!")
			get_tree().change_scene_to_file("res://level_2.tscn") 
		else:
			# Paalala kung bakit bawal pa lumipat
			if level_label:
				level_label.text = "HINDI PA PWEDE!\nPatayin mo muna ang " + str(current_count) + " pang apoy!"
				level_label.modulate = Color.RED
