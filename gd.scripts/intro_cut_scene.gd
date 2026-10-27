extends CanvasLayer

@onready var label = $Chatbox/DialogueLabel
@onready var citizen = $Citizensprite
@onready var phone = $Phone
@onready var bfp_logo = $bfplogo

var dialogue_text = [
	"CITIZEN: 'TULONG! MAY NASUSUNOG DITO SA MANDALUYONG!'",
	"*PHONE RINGING... KRING! KRING!*",
	"BFP DISPATCH: 'BFP Mandaluyong, what is your emergency?'",
	"CITIZEN: 'Sector 7 is on fire! Please send help immediately!'",
	"BFP DISPATCH: 'Copy that. Firefighter, move out and extinguish the fire!'"
]

var current_step = 0
var is_shaking = false
var original_phone_pos : Vector2

func _ready():
	original_phone_pos = phone.position
	# Paused ang game para intro lang ang gumagana
	get_tree().paused = true
	self.process_mode = Node.PROCESS_MODE_ALWAYS
	update_scene()

func _process(_delta):
	if is_shaking:
		var shake_offset = Vector2(randf_range(-5, 5), randf_range(-5, 5))
		phone.position = original_phone_pos + shake_offset
	else:
		phone.position = original_phone_pos

func _input(event):
	if event is InputEventMouseButton or event is InputEventKey:
		if event.is_pressed() and not event.is_echo():
			if Input.is_action_just_pressed("ui_accept") or (event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT):
				current_step += 1
				if current_step < dialogue_text.size():
					update_scene()
				else:
					finish_cutscene()

func update_scene():
	citizen.visible = false
	phone.visible = false
	bfp_logo.visible = false
	is_shaking = false
	
	label.text = dialogue_text[current_step]
	label.visible_ratio = 1.0 
	
	if current_step == 0 or current_step == 3:
		citizen.visible = true
	elif current_step == 1:
		phone.visible = true
		is_shaking = true
	elif current_step == 2 or current_step == 4:
		bfp_logo.visible = true

func finish_cutscene():
	# 1. Unpause muna para gumalaw ang bumbero mo sa main scene
	get_tree().paused = false
	
	# 2. ITO ANG IMPORTANTE: Palitan mo ang filename kung ano ang nasa FileSystem mo
	# Kung "main.tscn" ang pangalan ng gameplay scene mo, ito dapat:
	get_tree().change_scene_to_file("res://main.tscn")
	
	# 3. Burahin na ang intro layer (optional na ito pag change_scene pero safe itira)
	queue_free()
