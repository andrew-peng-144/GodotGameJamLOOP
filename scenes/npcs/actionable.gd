extends Area2D

const BALLOON = preload("res://scenes/ui/balloon.tscn")
@export var dialogue_resource: DialogueResource
@export var dialogue_start: String = "start"
@onready var letter: Sprite2D = %Letter
@onready var game_manager: Node = %GameManager
@onready var dark_overlay: ColorRect = %"Dark-Overlay"
@onready var tavern: TileMapLayer = %tavern
@onready var fence_body: StaticBody2D = %"fence-body"
@onready var fence_body_2: StaticBody2D = %"fence-body2"
@onready var tavern_door_body: StaticBody2D = %TavernDoorBody
@onready var wizard: CharacterBody2D = %Wizard
@onready var wizardSprite = wizard.get_node("AnimatedSprite2D")
@onready var white_overlay: ColorRect = %"White-Overlay"
@onready var branchSize = 1
@onready var branch_small: Sprite2D = %BranchSmall
@onready var branch_medium: Sprite2D = %BranchMedium
@onready var branch_big: Sprite2D = %BranchBig
@onready var music: AudioStreamPlayer2D = %Music


func playSound(name) -> void:
	if name == 'flipPaper':
		AudioManager.newspaper_flip.play()
	elif name == 'crumblePaper':
		AudioManager.paper_crumble.play()
	elif name == 'plantSeed':
		AudioManager.planting.play()
	elif name == 'watering':
		AudioManager.watering.play()
	elif name == 'coin-drop':
		AudioManager.coin_drop.play()
	elif name == 'cup-put-down':
		AudioManager.cup_put_down.play()
	elif name == 'gulp':
		AudioManager.gulp.play()
	elif name == 'rustle':
		AudioManager.rustle.play()
	elif name == 'cloak':
		AudioManager.cloak.play()
	elif name == 'unlock':
		AudioManager.unlock.play()
	elif name == 'glint':
		AudioManager.glint.play()
	elif name == 'hit':
		AudioManager.hit.play()
	elif name == 'spellcasting':
		AudioManager.spellcasting.play()
	else:
		print("Fail!")
		
func vanishPaper() -> void:
	letter.visible = false;
	
func watering() -> void:
	game_manager.player_body.get_node("AnimatedSprite2D").play(&"water")
	await game_manager.player_body.get_node("AnimatedSprite2D").animation_finished

func delay(time) -> void:
	await get_tree().create_timer(time).timeout

func addDarkOverlay() -> void:
	dark_overlay.modulate.a = 0.0
	dark_overlay.visible = true
	var tween := create_tween()
	tween.tween_property(dark_overlay, "modulate:a", 0.85, 0.85)

func removeDarkOverlay() -> void:
	var tween := create_tween()
	tween.tween_property(dark_overlay, "modulate:a", 0.0, 0.5)
	
func toggleCloakWizard() -> void:
	wizardSprite.play(&"reveal_noStaff")
	await wizardSprite.animation_finished
	wizardSprite.play(&"reveal_idle_noStaff")

func wizardGlint() -> void:
	wizardSprite.play(&"glint")
	await wizardSprite.animation_finished
	wizardSprite.play(&"idle")

func wizardLosesStaff() -> void:
	wizardSprite.play(&"idle_noStaff")

func openFence1() -> void:
	fence_body.get_node("CollisionShape2D").set_disabled(true)

func openFence2() -> void:
	fence_body_2.get_node("CollisionShape2D").set_disabled(true)

func openTavernDoor() -> void:
	tavern_door_body.get_node("TavernDoorSprite").flip_h = false
	tavern_door_body.get_node("CollisionShape2D").set_disabled(true)
	#var cell_coords = Vector2i(79, 20)
	#tavern.set_cell(cell_coords, 0, Vector2i(3, 11), 0)
	
func addWhiteOverlay() -> void:
	white_overlay.modulate.a = 0.0
	white_overlay.visible = true
	var tween := create_tween()
	tween.tween_property(white_overlay, "modulate:a", 0.85, 0.85)

func removeWhiteOverlay() -> void:
	var tween := create_tween()
	tween.tween_property(white_overlay, "modulate:a", 0.0, 0.5)
	
func revealWizardStaff() -> void:
	wizardSprite.play(&"reveal_idle")

#func growBranch() -> void:
#	if branchSize == 1:
#		branch_small.visible = true
#	elif branchSize == 2:
#		branch_small.visible = false
#		branch_medium.visible = true
#	else:
#		branch_medium.visible = false
#		branch_big.visible = true
#	branchSize = branchSize + 1

func toggleMusicVolume() -> void:
	print(music.volume_db)
	if music.volume_db == 0:
		music.volume_db = -10
	else:
		music.volume_db = 0

func action() -> void:
	var balloon: Node = BALLOON.instantiate()
	get_tree().current_scene.add_child(balloon)
	balloon.start(dialogue_resource, dialogue_start, [self])
