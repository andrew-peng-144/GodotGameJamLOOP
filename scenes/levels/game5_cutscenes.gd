extends Node

const BALLOON = preload("res://scenes/ui/balloon.tscn")

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var cutscene_camera: Camera2D = $Path2D/PathFollow2D/CutsceneCamera
@onready var path_follow_2d: PathFollow2D = $Path2D/PathFollow2D

@onready var intro_dialogue: Area2D = $IntroDialogue
@onready var letter: Sprite2D = %Letter

var is_opening_cutscene = false
var has_player_entered_area = false
var player = null
var is_path_following = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Globals.freeze_player_input = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	if false and is_opening_cutscene:
		if is_path_following:
			path_follow_2d.progress_ratio += 0.1 * delta
			
			if path_follow_2d.progress_ratio >= 1.0:
				cutsceneending()
				
	
func _on_player_detector_for_initial_cutscene_body_entered(body: Node2D) -> void:
	if body.is_in_group("player_body"):
		player = body
		if !has_player_entered_area:
			has_player_entered_area = true
			cutsceneopening()
			
func cutsceneopening():
	print("CUTSCENE OPENIGN!")
	is_opening_cutscene = true
	
	intro_dialogue.action() # Read intro dialogue
	await DialogueManager.dialogue_ended
	animation_player.play("cover_fade")
	await animation_player.animation_finished
	letter.get_node("Actionable").action() # Read letter automatically
	await DialogueManager.dialogue_ended
	Globals.freeze_player_input = false
	
	#player.camera_2d.enabled = false
	#enable our own camera
	#cutscene_camera.enabled = true
	#is_path_following = true
	
	
	
func cutsceneending():
	is_path_following = false
	is_opening_cutscene = false
	cutscene_camera.enabled = false
	player.camera_2d.enabled = true
	
