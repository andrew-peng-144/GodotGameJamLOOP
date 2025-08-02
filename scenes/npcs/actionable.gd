extends Area2D

const BALLOON = preload("res://scenes/ui/balloon.tscn")
@export var dialogue_resource: DialogueResource
@export var dialogue_start: String = "start"
@onready var letter: Sprite2D = $"../../Letter"
@onready var game_manager: Node = %GameManager

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
	else:
		print("Fail!")
		
func vanishPaper() -> void:
	letter.visible = false;
	
func watering() -> void:
	game_manager.player_body.get_node("AnimatedSprite2D").play(&"water")
	await game_manager.player_body.get_node("AnimatedSprite2D").animation_finished

func delay(time) -> void:
	await get_tree().create_timer(time).timeout

func action() -> void:
	var balloon: Node = BALLOON.instantiate()
	get_tree().current_scene.add_child(balloon)
	balloon.start(dialogue_resource, dialogue_start, [self])
