extends Node

#var game_started = false

var MC = "Clover"
var watering = false

var freeze_player_input = false # player cannot move or act. only UI actions allowed.

var coins = 0

var debug_text = true

var current_checkpoint_scene_path: String = ""
var current_checkpoint_position: Vector2 = Vector2.ZERO
var last_scene_transition_from_death = false # Whether the player just died, meaning the next scene transition should put the player at a checkpoint.
