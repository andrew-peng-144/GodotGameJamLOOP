extends Node

const BALLOON = preload("res://scenes/ui/balloon.tscn")

@onready var animation_player: AnimationPlayer = $AnimationPlayer

@onready var intro_dialogue: Area2D = $IntroDialogue
@onready var letter: Sprite2D = %Letter
@onready var color_rect: ColorRect = $ColorRect


var player = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Globals.freeze_player_input = true
	color_rect.visible = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

				
	
func _on_player_detector_for_initial_cutscene_body_entered(body: Node2D) -> void:
	if body.is_in_group("player_body"):
		player = body
		cutsceneopening()
			
func cutsceneopening():
	if Globals.played_intro_cutscene:
		Globals.freeze_player_input = false
		color_rect.visible = false
		return
	print("CUTSCENE OPENIGN!")
	
	intro_dialogue.action() # Read intro dialogue
	await DialogueManager.dialogue_ended
	animation_player.play("cover_fade")
	await animation_player.animation_finished
	letter.get_node("Actionable").action() # Read letter automatically
	await DialogueManager.dialogue_ended
	Globals.freeze_player_input = false
	Globals.played_intro_cutscene = true
	queue_free()

	
