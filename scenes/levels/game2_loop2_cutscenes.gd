extends Node

@onready var letter: Sprite2D = %Letter
#@onready var intro_dialogue: Area2D = $IntroDialogue
var player = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_player_detector_for_initial_cutscene_body_entered(body: Node2D) -> void:
	if body.is_in_group("player_body"):
		player = body
		cutsceneopening()

func cutsceneopening():
	letter.get_node("Actionable").action() # Read letter automatically
	await DialogueManager.dialogue_ended
	Globals.freeze_player_input = false
	queue_free()

	
