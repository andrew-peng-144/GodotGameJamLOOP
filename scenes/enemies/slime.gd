extends CharacterBody2D

@export var speed = 60.0
@export var jump_velocity = -250
@onready var game_manager: Node = %GameManager

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var direction = 1

var is_chasing_player = true
var is_roaming = false

var dead = false

@onready var ray_cast_right: RayCast2D = $RayCastRight
@onready var ray_cast_left: RayCast2D = $RayCastLeft
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var collision_shape_top: CollisionShape2D = $TopArea/CollisionShape2D

		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		

		
	if !dead:
		# Change direction when hitting wall.
		if ray_cast_right.is_colliding():
			direction = -1
		if ray_cast_left.is_colliding():
			direction = 1
			
		if !is_chasing_player:
			velocity.x += direction * speed * delta # accleration?
		else:
			var dir_to_player = position.direction_to(game_manager.player_body.position)
			velocity.x = dir_to_player.x * speed
			
		is_roaming = true
	elif dead:
		velocity.x = 0
		
	move_and_slide()
	update_animations(direction)
	
func update_animations(direction):
	# Flip the Sprite
	if direction > 0:
		animated_sprite.flip_h = false
	elif direction < 0:
		animated_sprite.flip_h = true
	
	# Play animations
	if is_on_floor():
		if direction == 0:
			animated_sprite.play("idle")
		else:
			animated_sprite.play("run")
	else:
		animated_sprite.play("jump")
		
func die():
	animated_sprite.play("death")
	collision_shape.set_deferred("disabled", true) # "Can't change this state while flushing queries" error
	collision_shape_top.set_deferred("disabled", true)
	await animated_sprite.animation_finished
	queue_free()
	
	


func _on_area_2d_body_entered(body: Node2D) -> void:
	print(body.name)
	if(body.is_in_group("player_body")):
		print("FROM ANOVE!!")
		die()
		


func _on_direction_timer_timeout() -> void:
	$DirectionTimer.wait_time = choose([1.5,2.0,2.5])
	if !is_chasing_player:
		direction = choose([-1.0, 1.0])
		velocity.x = 0
		

func choose(array):
	array.shuffle()
	return array.front()
