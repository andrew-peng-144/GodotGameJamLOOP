extends CharacterBody2D

@export var speed = 60.0
@export var jump_velocity = -250

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var direction = 1

@onready var ray_cast_right: RayCast2D = $RayCastRight
@onready var ray_cast_left: RayCast2D = $RayCastLeft
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		
	# Change direction when hitting wall.
	if ray_cast_right.is_colliding():
		print ("YE")
		direction = -1
	if ray_cast_left.is_colliding():
		direction = 1
		
	velocity.x = direction * speed
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
