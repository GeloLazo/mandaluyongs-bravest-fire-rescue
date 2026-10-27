extends Area2D

@export var respawn_time = 10.0 # Gaano katagal bago bumalik (seconds)

func _on_body_entered(body: Node2D) -> void:
	# Chine-check kung player ang nakabangga
	if body.has_method("activate_super_hose"):
		
		# 1. I-play ang sound (Siguraduhin na may PickupSound node ka)
		if has_node("PickupSound"):
			$PickupSound.play()
		
		# 2. I-activate ang power-up sa player (Duration: 10s)
		body.activate_super_hose(10.0)
		
		# 3. ITAGO ANG HOSE (Huwag i-delete!)
		hide_hose()
		
		# 4. TIMER PARA SA RESPAWN
		await get_tree().create_timer(respawn_time).timeout
		
		# 5. PAKITA ULI ANG HOSE
		show_hose()

func hide_hose():
	$Sprite2D.visible = false
	# Mahalaga 'to: I-off ang monitoring para 'di makuha habang invisible
	set_deferred("monitoring", false) 
	if has_node("AnimationPlayer"):
		$AnimationPlayer.stop()

func show_hose():
	$Sprite2D.visible = true
	# I-on uli ang monitoring para mapulot uli
	set_deferred("monitoring", true) 
	if has_node("AnimationPlayer"):
		$AnimationPlayer.play("float")
	print("Superhose is back!")
