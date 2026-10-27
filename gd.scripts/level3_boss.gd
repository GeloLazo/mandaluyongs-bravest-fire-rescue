extends Node

# 1. PATHS (Siguraduhing tama ang spelling sa Scene Tree!)
@onready var boss_ui = $BossUI
@onready var progress_bar = $BossUI/ProgressBar
@onready var dialog_panel = $BossUI/Panel
@onready var dialog_label = $BossUI/Panel/Label

# CAMERA SETUP
@onready var player_cam = $Player/Camera2D
@onready var boss_cam = $BossFire/BossCam

func _ready():
	# Siguraduhin nating invisible muna ang UI panel sa start
	if dialog_panel:
		dialog_panel.visible = false 

	# 2. I-FREEZE ANG PLAYER AT BOSS (Huwag muna silang gumalaw)
	# Ginagamit natin ang pangalan na nasa listahan mo sa kaliwa
	if has_node("Player"):
		$Player.set_physics_process(false)
	
	if has_node("BossFire"):
		$BossFire.set_physics_process(false)
	
	# 3. SIMULAN ANG VILLAIN REVEAL
	start_boss_intro()

func start_boss_intro():
	# A. TUTOK ANG CAMERA KAY BOSS!
	if boss_cam:
		boss_cam.make_current()
	
	# B. LABAS ANG SALITA SA SCREEN!
	if dialog_panel and dialog_label:
		dialog_panel.visible = true
		dialog_label.text = "Bwahahaha! Ako ang nagpapasimuno ng lahat ng apoy na 'to!"
	
	await get_tree().create_timer(3.0).timeout
	
	if dialog_label:
		dialog_label.text = "Kailangan mo akong talunin para matigil ang sunog! HANDA KA NA BA?!"
	
	await get_tree().create_timer(3.0).timeout
	
	# 4. ITAGO ANG DIALOG AT SIMULAN ANG LABAN!
	if dialog_panel:
		dialog_panel.visible = false
	
	# C. BALIK ANG CAMERA SA PLAYER!
	if player_cam:
		player_cam.make_current()
	
	if has_node("Player"):
		$Player.set_physics_process(true)
	
	if has_node("BossFire"):
		$BossFire.set_physics_process(true)
		# TAWAGIN ANG FUNCTION SA BOSS PARA MAGSIMULA NG LABAN
		if $BossFire.has_method("start_boss"):
			$BossFire.start_boss() # Siguraduhin mong may ganito sa fire_boss.gd
	
	print("LABAN NA, GAGO!")
