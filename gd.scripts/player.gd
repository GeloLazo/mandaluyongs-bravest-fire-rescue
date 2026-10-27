extends CharacterBody2D

# --- CONFIGURATION ---
const SPEED = 300.0
const JUMP_VELOCITY = -600.0
const SHOOT_DELAY = 0.05 

# --- AMMO & GAME STATE ---
var max_ammo = 50
var current_ammo = 50
var shoot_timer = 0.0
var is_super_hose = false # Power-up state

# --- HEALTH SYSTEM ---
var health = 5
signal health_updated(current_health)

# --- REFERENCES ---
@onready var sprite = $AnimatedSprite2D
@onready var muzzle = $muzzle 
@onready var water_bullet_scene = preload("res://waterbullet.tscn")
@onready var water_sfx = $WaterSFX

# UI Paths
@onready var ammo_label = get_parent().get_node_or_null("CanvasLayer/Label")
@onready var time_label = get_parent().get_node_or_null("CanvasLayer2/TimeLabel")
@onready var levellabel = get_parent().get_node_or_null("CanvasLayer2/Levellabel")
@onready var game_timer = get_parent().get_node_or_null("Timer")
@onready var fade_overlay = get_parent().get_node_or_null("TransitionLayer/FadeOverlay")

func _ready():
	update_ammo_ui()
	if levellabel:
		levellabel.text = ""
	
	if fade_overlay:
		fade_overlay.visible = true
		fade_overlay.modulate.a = 1.0 
		var tween = get_tree().create_tween()
		tween.tween_property(fade_overlay, "modulate:a", 0.0, 2.0).set_trans(Tween.TRANS_SINE)
		await tween.finished
		fade_overlay.visible = false 

func _physics_process(delta: float) -> void:
	update_timer_ui()
	apply_gravity(delta)
	handle_movement()
	handle_shooting(delta)
	update_animations()
	update_muzzle_position()
	move_and_slide()

# --- HEALTH FUNCTIONS ---
func take_damage():
	health -= 1
	health_updated.emit(health)
	
	# ETO ANG DINAGDAG NATIN PARA GUMALAW YUNG PUSO SA SCREEN!
	update_heart_ui() 
	
	print("Aray! Buhay na lang: ", health)
	
	# Optional: Dagdagan natin ng flash pula para ramdam ang damage
	sprite.modulate = Color(10, 1, 1)
	await get_tree().create_timer(0.1).timeout
	sprite.modulate = Color(1, 1, 1)
	
	if health <= 0:
		get_tree().reload_current_scene()

# DAGDAG MO RIN 'TONG FUNCTION NA 'TO SA BABA NG TAKE_DAMAGE:
func update_heart_ui():
	# Hanapin ang container (Siguraduhin na tama ang pangalan sa Scene Tree!)
	var heart_container = get_parent().get_node_or_null("PlayerUI/HeartsContainer")
	
	if heart_container:
		var hearts_list = heart_container.get_children()
		for i in range(hearts_list.size()):
			# Ipakita lang ang puso kung ang index ay mas mababa sa health
			# Halimbawa: kung health = 4, ang pang-limang puso (index 4) ay mawawala
			hearts_list[i].visible = i < health

func update_timer_ui():
	if game_timer and time_label:
		time_label.text = "Timer: " + str(int(game_timer.time_left))

func apply_gravity(delta: float):
	if not is_on_floor():
		velocity += get_gravity() * delta

func handle_movement():
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	# Eto ang magic line para sa Speed Boost
	var current_multiplier = get_meta("speed_multiplier") if has_meta("speed_multiplier") else 1.0
	var actual_speed = SPEED * current_multiplier
	
	var direction = Input.get_axis("move_left", "move_right")
	if direction != 0:
		velocity.x = direction * actual_speed # Ginamit natin yung boosted speed dito
		if not Input.is_action_pressed("look_up"):
			sprite.flip_h = (direction < 0)
	else:
		velocity.x = move_toward(velocity.x, 0, actual_speed)

func update_animations():
	var is_aiming_up = Input.is_action_pressed("look_up")
	if is_on_floor():
		if is_aiming_up: sprite.play("lookup")
		elif velocity.x != 0: sprite.play("run")
		else: sprite.play("idle")
	else:
		sprite.play("jump")

func update_muzzle_position():
	if not muzzle: return
	if sprite.animation == "lookup":
		muzzle.position = Vector2(-70.0, -45.0) 
	else:
		var offset_x = 60.0
		var offset_y = -58.0
		muzzle.position.x = -offset_x if sprite.flip_h else offset_x
		muzzle.position.y = offset_y

# --- SHOOTING LOGIC (NA MAY POWER-UP) ---
func handle_shooting(delta: float):
	shoot_timer -= delta
	var is_aiming_up = Input.is_action_pressed("look_up")
	
	if Input.is_action_pressed("Shoot") and is_on_floor() and current_ammo > 0:
		if water_sfx and not water_sfx.playing:
			water_sfx.play()
		
		if shoot_timer <= 0:
			shoot_water(is_aiming_up)
			
			# 1. UNLIMITED AMMO PAG NAKA-POWERUP
			if not is_super_hose:
				current_ammo -= 1  
			
			# 2. MACHINE GUN SPEED (0.02 vs 0.05)
			if is_super_hose:
				shoot_timer = 0.02
			else:
				shoot_timer = SHOOT_DELAY 
				
			update_ammo_ui()
	else:
		if water_sfx and water_sfx.playing:
			water_sfx.stop()

func shoot_water(aim_up: bool):
	if not water_bullet_scene or not muzzle: return
	var bullet = water_bullet_scene.instantiate()
	get_parent().add_child(bullet)
	bullet.global_position = muzzle.global_position
	var shoot_dir = Vector2.UP if aim_up else (Vector2.LEFT if sprite.flip_h else Vector2.RIGHT)
	if "bullet_direction" in bullet:
		bullet.bullet_direction = shoot_dir.normalized()
	bullet.rotation = shoot_dir.angle()
	bullet.scale.y = -abs(bullet.scale.y) if shoot_dir.x < 0 else abs(bullet.scale.y)

func update_ammo_ui():
	if ammo_label:
		ammo_label.text = "Bullet: " + str(current_ammo) + "/" + str(max_ammo)

func reload_ammo():
	current_ammo = max_ammo
	update_ammo_ui() 

func add_partial_ammo(amount: int):
	current_ammo = clamp(current_ammo + amount, 0, max_ammo)
	update_ammo_ui()

# --- SIGNALS & EVENTS ---
func _on_reload_station_body_entered(body: Node2D) -> void:
	if body == self: reload_ammo()

func _on_firehydrant_body_entered(body: Node2D) -> void:
	if body == self: 
		add_partial_ammo(20)

func _on_timer_timeout() -> void:
	get_tree().reload_current_scene()

# --- POWER-UP ACTIVATION ---
func activate_super_hose(duration: float):
	if is_super_hose: return 
	
	print("SUPER HOSE ACTIVATED!") 
	is_super_hose = true
	sprite.modulate = Color(0, 2, 5) # Malakas na Cyan glow
	
	await get_tree().create_timer(duration).timeout
	
	is_super_hose = false
	sprite.modulate = Color(1, 1, 1) # Balik normal
	print("SUPER HOSE EXPIRED")
# --- SPEED POWER-UP ---
var original_speed = 300.0 # Dapat match sa SPEED constant mo

func activate_speed_boost(duration: float, multiplier: float):
	print("SPEED BOOST ACTIVATED!")
	# Imbes na baguhin yung constant, yung velocity calculation ang apektuhan natin
	var boost_speed = original_speed * multiplier
	
	# Pansamantalang palitan ang SPEED value sa handle_movement logic
	# Note: Dahil constant ang SPEED, kailangan natin ng variable para sa current speed
	# Pero para madali, baguhin natin yung modulate para may visual effect
	sprite.modulate = Color(1, 2, 1) # Green Glow para sa Speed
	
	# Dito natin ia-apply yung logic (Dapat may variable ka na 'current_speed' sa handle_movement)
	# Pero heto ang shortcut:
	set_meta("speed_multiplier", multiplier) 
	
	await get_tree().create_timer(duration).timeout
	
	set_meta("speed_multiplier", 1.0)
	sprite.modulate = Color(1, 1, 1) # Balik normal
	print("SPEED BOOST EXPIRED")
