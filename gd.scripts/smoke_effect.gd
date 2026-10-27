extends GPUParticles2D

func _ready():
	emitting = true # Siguradong sasabog bawat labas
	# Hintayin matapos yung lifetime (0.8s) bago burahin sa memory
	await get_tree().create_timer(lifetime).timeout
	queue_free()
