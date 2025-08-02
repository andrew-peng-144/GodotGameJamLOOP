extends Area2D

const BALLOON = preload("res://scenes/ui/balloon.tscn")
@export var dialogue_resource: DialogueResource
@export var dialogue_start: String = "start"
@onready var letter: Sprite2D = $"../../Letter"

func playSound(name) -> void:
	if name == 'flipPaper':
		print("res://assets/sounds/page-flip-99838.mp3")
	elif name == 'hi2':
		print(name)
	else:
		print("Fail!")
		
func vanishPaper() -> void:
	letter.visible = false;

func action() -> void:
	var balloon: Node = BALLOON.instantiate()
	get_tree().current_scene.add_child(balloon)
	balloon.start(dialogue_resource, dialogue_start, [self])
