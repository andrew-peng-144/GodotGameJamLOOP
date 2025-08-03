extends Area2D
class_name Door

@export var next_scene_file = "res://scenes/levels/game5.tscn"
#@onready var scene_transition_animation_player: Node = $SceneTransitionAnimation/AnimationPlayer
#
#
#func _on_body_entered(body: Node2D) -> void:
	#if body is Player:
		#print(body)
		#scene_transition_animation_player.play("fade_in")
		#body.is_stopped = true
		#await scene_transition_animation_player.animation_finished
		#get_tree().change_scene_to_file("res://scenes/levels/game5.tscn")
		#body.is_stopped = false
