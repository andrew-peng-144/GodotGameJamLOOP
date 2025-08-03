extends CharacterBody2D

@export var speed = 50.0
@export var jump_velocity = -250
@export var player_body: CharacterBody2D
@export var bounce = 300

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


var dead = false

@onready var ray_cast_right: RayCast2D = $RayCastRight
@onready var ray_cast_left: RayCast2D = $RayCastLeft
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var collision_shape_top: CollisionShape2D = $TopArea/CollisionShape2D
@onready var kill_zone_collision_shape: CollisionShape2D = $KillZone/CollisionShape2D
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		

		
	if !dead:

		# chase player
		var dir_to_player = position.direction_to(player_body.position)
		velocity.x = dir_to_player.x * speed

	elif dead:
		velocity.x = 0
		return
		
	move_and_slide()
	update_animations()
	
func update_animations():
	# Flip the Sprite
	if velocity.x > 0:
		animated_sprite.flip_h = false
	elif velocity.x < 0:
		animated_sprite.flip_h = true
	
	# Play animations
	if is_on_floor():
		if velocity.x == 0:
			animated_sprite.play("idle")
		else:
			animated_sprite.play("run")
	else:
		animated_sprite.play("jump")
		
func die():
	dead = true
	#collision_shape.disabled = true
	collision_shape_top.queue_free()
	kill_zone_collision_shape.queue_free()
	animated_sprite.play("death")
	await animated_sprite.animation_finished
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
		
# KillZone
func _on_kill_zone_body_entered(body: Node2D) -> void:
	print(body.name)
	if(body.is_in_group("player_body")):
		body.DIE()

func _on_direction_timer_timeout() -> void:
	$DirectionTimer.wait_time = choose([1.0,1.25,1.5,1.75,2.0])
	#direction = choose([-1.0, 1.0])
	jump()
	velocity.x = 0
		
func jump():
	velocity.y = jump_velocity

func choose(array):
	array.shuffle()
	return array.front()
