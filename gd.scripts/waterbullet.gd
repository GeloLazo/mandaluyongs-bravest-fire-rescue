extends Area2D

var speed = 500.0 
var bullet_direction = Vector2.RIGHT 
var lifetime = 0.4 

func _process(delta: float) -> void:
	# Global position para sumunod sa koordinasyon ng mundo
	global_position += bullet_direction * speed * delta
	
	lifetime -= delta
	if lifetime <= 0:
		queue_free() 

func _on_area_entered(area: Area2D) -> void:
	if area.has_method("take_damage"):
		area.take_damage(10) 
	elif area.get_parent() and area.get_parent().has_method("take_damage"):
		area.get_parent().take_damage(5)
