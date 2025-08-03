extends Node2D

@export var speed = 50.0
@export var jump_velocity = -250
@export var player_body: CharacterBody2D
@export var bounce = 300
@export var flight_distance = 80

@onready var killzone: Area2D = $Killzone
@onready var animated_sprite_2d: AnimatedSprite2D = $Killzone/AnimatedSprite2D
@onready var top_area: Area2D = $Killzone/TopArea

var tween: Tween

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var direction = 1

var dead = false

func _ready():
	tween = create_tween().set_loops()
	loop_tweens()

func loop_tweens():
	tween.tween_property(self.get_node("Killzone"), "position", Vector2(0, -flight_distance), 2.0).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self.get_node("Killzone"), "position", Vector2(0, 0), 2.0).set_ease(Tween.EASE_IN_OUT)
	
func die():
	dead = true
	#collision_shape.disabled = true
	top_area.queue_free()
	killzone.get_node("CollisionShape2D").queue_free()
	animated_sprite_2d.play("death")
	await animated_sprite_2d.animation_finished
	#print("waited.")
	queue_free()
	
	

# TopArea
func _on_top_area_body_entered(body: Node2D) -> void:
	#print(body.name)
	if(body.is_in_group("player_body")):
		#print("FROM ANOVE!!")
		body.velocity.y = -bounce
		body.make_invuln(0.2)
		die()

# Killzone (player already checks.)
#func _on_killzone_body_entered(body: Node2D) -> void:
	#print(body.name)
	#if(body.is_in_group("player_body")):
		#body.DIE()
