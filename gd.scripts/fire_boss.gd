extends Area2D

@export var health = 1590 # Grabe ang kunat nito, gago!
@export var fireball_scene: PackedScene 

@onready var sprite = $Sprite2D
@onready var timer = $ShootTimer

var is_active = false # Naka-false muna para sa intro dialogue

func _ready():
	# 1. Idle Animation (Lulutang-lutang)
	var tween = create_tween().set_loops()
	tween.tween_property(sprite, "position:y", -25, 1.5).as_relative().set_trans(Tween.TRANS_SINE)
	tween.tween_property(sprite, "position:y", 25, 1.5).as_relative().set_trans(Tween.TRANS_SINE)
	
	# 2. I-setup ang Health Bar sa simula
	var hb = get_tree().get_first_node_in_group("BossBar")
	if hb:
		hb.max_value = health # Gawin nating 1590 ang max sa bar
		hb.value = health

# ITO ANG TATAWAGIN NG MAP SCRIPT PAGKATAPOS NG INTRO
func start_boss():
	is_active = true
	if not timer.timeout.is_connected(_on_timer_timeout):
		timer.timeout.connect(_on_timer_timeout)
	
	# PALITAN MO 'TO: Gawin nating 2.0 para dahan-dahan lang
	timer.start(2.0) 
	
	print("Laban na talaga! Dahan-dahan lang ang buga.")

func _on_timer_timeout():
	if not is_active: return 
	
	var player = get_tree().get_first_node_in_group("Player")
	if player and fireball_scene:
		var ball = fireball_scene.instantiate()
		get_parent().add_child(ball)
		ball.global_position = global_position
		
		# ETO ANG MAGIC: Kunin ang direksyon ISANG BESES LANG
		var target_direction = (player.global_position - global_position).normalized()
		
		# I-pass ang direksyon sa fireball
		if "direction" in ball:
			ball.direction = target_direction
		
		timer.start(2.0)

func take_damage(amount = 1):
	if not is_active: return # Hindi pwedeng saktan habang nag-i-intro
	
	health -= amount
	
	# Update ang Health Bar
	var hb = get_tree().get_first_node_in_group("BossBar")
	if hb: 
		hb.value = health # Bababa na 'to nang tama base sa 1590
	
	# Flash Pula
	sprite.modulate = Color(10, 1, 1)
	await get_tree().create_timer(0.1).timeout
	sprite.modulate = Color(1, 1, 1)
	
	if health <= 0:
		die()

func die():
	get_tree().change_scene_to_file("res://win_screen.tscn")
	queue_free()
