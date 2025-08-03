extends Area2D
class_name Door

@export var door_id = "default"
@export var next_scene_file = "res://scenes/levels/game5.tscn"
@export var next_scene_door_id = "default"
@export var door_direction_x = 0

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

func _ready():
	if self.is_in_group("scene_transition_areas"):
		# Disable Scene Transition Area for short time to prevent looping.
		collision_shape_2d.disabled = true
		await get_tree().create_timer(1.5).timeout
		collision_shape_2d.disabled = false
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
