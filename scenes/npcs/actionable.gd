extends Area2D

const BALLOON = preload("res://scenes/ui/balloon.tscn")
@export var dialogue_resource: DialogueResource
@export var dialogue_start: String = "start"

func action() -> void:
	var balloon: Node = BALLOON.instantiate()
	get_tree().current_scene.add_child(balloon)
	balloon.start(dialogue_resource, dialogue_start)
