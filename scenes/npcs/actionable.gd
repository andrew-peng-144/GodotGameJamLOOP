extends Area2D

const BALLOON = preload("res://scenes/ui/balloon.tscn")
@export var dialogue_resource: DialogueResource
@export var dialogue_start: String = "start"
@onready var letter: Sprite2D = %Letter
@onready var game_manager: Node = %GameManager
@onready var dark_overlay: ColorRect = $"../../Dark-Overlay"
@onready var tavern: TileMapLayer = $"../../TileMapLayers/tavern"
@onready var fence_body: StaticBody2D = %"fence-body"
@onready var fence_body_2: StaticBody2D = %"fence-body2"
@onready var tavern_door_body: StaticBody2D = %TavernDoorBody


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
	print("toggle cloak wizard")

func openFence1() -> void:
	fence_body.get_node("CollisionShape2D").set_disabled(true)

func openFence2() -> void:
	fence_body_2.get_node("CollisionShape2D").set_disabled(true)

func openTavernDoor() -> void:
	tavern_door_body.get_node("TavernDoorSprite").flip_h = false
	tavern_door_body.get_node("CollisionShape2D").set_disabled(true)
	#var cell_coords = Vector2i(79, 20)
	#tavern.set_cell(cell_coords, 0, Vector2i(3, 11), 0)
	print("open door")

func action() -> void:
	var balloon: Node = BALLOON.instantiate()
	get_tree().current_scene.add_child(balloon)
	balloon.start(dialogue_resource, dialogue_start, [self])
