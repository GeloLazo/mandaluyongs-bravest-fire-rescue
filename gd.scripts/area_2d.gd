extends Area2D

var health = 50
var max_health = 50

# WALA NA TAYONG _READY DITO PARA HINDI MAG-DOUBLE COUNT.

func take_damage(amount):
	health -= amount
	print("Tinamaan ang apoy! Health: ", health)
	
	# Scaling logic para lumiliit ang apoy
	var s = clamp(float(health) / float(max_health), 0.4, 1.0)
	scale = Vector2(s, s) 
	
	if health <= 0:
		print("--- APOY NAAPULA! ---")
		
		# 1. Alisin muna sa group para bawas na sa listahan ni Godot
		remove_from_group("mga_apoy")
		
		# 2. Hintayin ang frame para ma-refresh ang system
		await get_tree().process_frame 
		
		# 3. Bilangin kung ilan na lang ang natira
		var count = get_tree().get_nodes_in_group("mga_apoy").size()
		
		# 4. Heto ang update sa Output window:
		print("------------------------------------------")
		print("UPDATE: Natitirang apoy: " + str(count))
		print("------------------------------------------")
		
		# 5. Burahin na ang node
		queue_free()
