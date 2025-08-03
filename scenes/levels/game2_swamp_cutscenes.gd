extends Node

@onready var intro_dialogue: Area2D = $IntroDialogue
var player = null
@onready var playerInstance: Player = $"../Player"
@onready var wizard: Area2D = %Wizard
@onready var intro_dialogue_collision_shape: CollisionShape2D = %introDialogueCollisionShape

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	#Globals.loop_count = 2
	if Globals.hasVisitedSwamp:
		# with wizard
		# cutscene opening should change
		playerInstance.position = Vector2(1574, 236)
		intro_dialogue_collision_shape.position = Vector2(1574, 236)
		wizard.position = Vector2(1499, 241)
		intro_dialogue.dialogue_start = "wizardSwamp"
	Globals.hasVisitedSwamp = true
	#else:
		#print("Loop count isn't 0 or 1...?")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_player_detector_for_initial_cutscene_body_entered(body: Node2D) -> void:
	if body.is_in_group("player_body"):
		player = body
		cutsceneopening()

func cutsceneopening():
	intro_dialogue.action() # Automatic cutscene
	await DialogueManager.dialogue_ended
	Globals.freeze_player_input = false
	queue_free()

	
