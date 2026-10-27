extends Area2D

var speed = 400
# 1. Siguraduhin na tama ang pangalan ng scene ng usok mo dito!
@onready var smoke_scene = preload("res://smoke_effect.tscn")

func _process(delta):
	# Pabagsakin ang bato
	position.y += speed * delta
	
	# Burahin pag lumampas na sa screen (para hindi mag-lag)
	if position.y > 2000:
		queue_free()

func _on_body_entered(body):
	# 2. TATAWAGIN ANG USOK (Dapat mauna 'to bago ang queue_free)
	spawn_smoke_effect()
	
	# 3. LOGIC PARA SA DAMAGE
	if body.name == "Player":
		if body.has_method("take_damage"):
			body.take_damage()
	
	# 4. BURAHIN ANG BATO PAGKATAPOS TUMAMA KAHIT SAAN
	queue_free()

# 5. ANG MAGIC FUNCTION PARA SA USOK
func spawn_smoke_effect():
	if smoke_scene:
		var s = smoke_scene.instantiate()
		# Inilalagay sa main level para hindi mabura kasama ng bato
		get_parent().add_child(s)
		# Itatapat sa kung nasaan ang bato nung tumama siya
		s.global_position = global_position
