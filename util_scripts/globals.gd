extends Node

#var game_started = false

var MC = "Clover"
var watering = false

var freeze_player_input = false # player cannot move or act. only UI actions allowed.
var godmode = true 

var coins = 0

var debug_text = false

var current_checkpoint_scene_path: String = ""
var current_checkpoint_position: Vector2 = Vector2.ZERO
var last_scene_transition_from_death = false # Whether the player just died, meaning the next scene transition should put the player at a checkpoint.
var door_id_to_spawn_at: String
var door_direction_x = 0 # Which direction is the player moving toward when entering this Scene Transition Area? 1 = right,  -1 = left,  0 = neutral

var loop_count = 0 #0 = never looped, 1 = looped once, 2 = looped twice, etc
var hasVisitedSwamp = false

# player is immortal
