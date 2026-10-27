extends Area2D

@export var respawn_time = 10.0 # Dito mo i-set kung gaano katagal babalik

func _on_body_entered(body: Node2D) -> void:
	if body.has_method("activate_speed_boost"):
		# 1. I-play ang sound
		if has_node("AudioStreamPlayer2D"):
			$AudioStreamPlayer2D.play()
		
		# 2. TATAWAG SA PLAYER: (Duration: 7s, Speed: 1.8x)
		body.activate_speed_boost(7.0, 1.8)
		
		# 3. ITAGO ANG ITEM (Huwag i-delete!)
		hide_boost()
		
		# 4. MAGHINTAY NG 10 SECONDS PARA BUMALIK
		await get_tree().create_timer(respawn_time).timeout
		
		# 5. PAKITA ULI ANG ITEM
		show_boost()

func hide_boost():
	$Sprite2D.visible = false
	set_deferred("monitoring", false) # I-off ang bungguan para 'di ma-trigger habang wala pa
	if has_node("AnimationPlayer"):
		$AnimationPlayer.stop()

func show_boost():
	$Sprite2D.visible = true
	set_deferred("monitoring", true) # I-on uli ang bungguan
	if has_node("AnimationPlayer"):
		$AnimationPlayer.play("float")
	print("Speed Boost is back!")
