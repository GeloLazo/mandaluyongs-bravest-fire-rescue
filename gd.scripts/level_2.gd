extends Node

@export var bato_scene: PackedScene 

# 1. UI NODES
@onready var timer_label = $CanvasLayer2/TimeLabel
@onready var apoy_label = $CanvasLayer2/Levellabel
@onready var heart_icons = [
	$UI/HBoxContainer/Heart1,
	$UI/HBoxContainer/Heart2,
	$UI/HBoxContainer/Heart3,
	$UI/HBoxContainer/Heart4,
	$UI/HBoxContainer/Heart5
]

# 2. VARIABLES
var time_left = 100 
var apoy_count = 0
var level_cleared = false 

func _ready():
	await get_tree().process_frame 
	
	# Bibilangin lahat ng apoy sa group
	var all_fires = get_tree().get_nodes_in_group("mga_apoy")
	apoy_count = all_fires.size()
	
	# Debug: Para makita mo sa start kung tama ang bilang
	print("Level 2 Start: ", apoy_count, " fires found.")
	
	for apoy in all_fires:
		if apoy.has_signal("area_entered") and not apoy.area_entered.is_connected(_on_fire_hit):
			apoy.area_entered.connect(_on_fire_hit.bind(apoy))
	
	update_ui()
	
	# Countdown Timer
	var countdown_timer = Timer.new()
	add_child(countdown_timer)
	countdown_timer.wait_time = 1.0
	countdown_timer.timeout.connect(_on_countdown_timeout)
	countdown_timer.start()

	# Ikonekta ang Player sa Hearts UI
	var player_node = get_node_or_null("Player") 
	if player_node:
		player_node.health_updated.connect(_on_player_health_updated)

# 3. FIRE HIT LOGIC (FIXED: Anti-Bug/Double Count)
func _on_fire_hit(area, target_fire):
	# Siguraduhin na tubig ang tumama at ang apoy ay hindi pa "pamatay"
	if area.name == "waterbullet" or area.is_in_group("water"):
		if not is_instance_valid(target_fire) or target_fire.is_queued_for_deletion():
			return
		
		# Patayin muna ang apoy bago bawasan ang counter (Para iwas bug)
		target_fire.queue_free()
		on_fire_extinguished() 

func on_fire_extinguished():
	# Siguraduhin na hindi mag-ne-negative ang count
	if apoy_count > 0:
		apoy_count -= 1
	
	update_ui()
	
	if apoy_count <= 0:
		apoy_count = 0
		level_cleared = true
		update_ui()
		print("Lahat ng apoy patay na! Punta na sa FinishLine!")

# 4. FINISH LINE LOGIC (Dapat Capital 'P' ang Player!)
func _on_finish_line_body_entered(body):
	print("Collision detected with: ", body.name)
	
	if body.name == "Player":
		if level_cleared:
			print("NEXT LEVEL: Boss Fire Scene Loading...")
			get_tree().change_scene_to_file("res://boss_fire.tscn")
		else:
			print("Bawal pa lumipat, may apoy pa!")

# 5. UI UPDATE
func update_ui():
	if timer_label:
		timer_label.text = "Timer: " + str(time_left)
	
	if apoy_label:
		if level_cleared:
			apoy_label.text = "LEVEL CLEARED! GO TO FINISH LINE!"
			apoy_label.add_theme_color_override("font_color", Color.YELLOW)
		else:
			apoy_label.text = "Natitirang apoy: " + str(apoy_count)

func _on_countdown_timeout():
	if time_left > 0:
		time_left -= 1
		update_ui()

# 6. SPAWN BATO (Fixed node reference)
func _on_spawn_timer_timeout():
	if bato_scene:
		var bato = bato_scene.instantiate()
		var player_node = get_node_or_null("Player")
		if player_node:
			var spawn_x = randf_range(player_node.position.x - 600, player_node.position.x + 600)
			bato.position = Vector2(spawn_x, player_node.position.y - 500)
			add_child(bato)

# 7. HEARTS
func _on_player_health_updated(current_health):
	if current_health >= 0 and current_health < heart_icons.size():
		heart_icons[current_health].visible = false
