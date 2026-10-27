extends Area2D

var speed = 250 # Bagalan mo lang para maiwasan
var direction = Vector2.ZERO # Dito mase-save yung target direction

func _process(delta):
	# Dito, dideretso lang siya sa direksyon na binigay ni Boss
	# Hindi na siya magbabago kahit nasaan na ang player
	global_position += direction * speed * delta

func _on_body_entered(body):
	if body.has_method("take_damage"):
		body.take_damage()
	queue_free() # Mawawala pag tumama
