extends CharacterBody2D


const ACCEL = 1000.0
const DECEL = 800.0
const JUMP_VELOCITY = -360.0
const MAX_SPEED = 130.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var actionable_finder: Area2D = $DirectionMarker/ActionableFinder
@onready var direction_marker: Marker2D = $DirectionMarker
@onready var after_death_timer: Timer = $AfterDeathTimer


var input_direction: int = 0

var dialogue_locked = false
var is_dead = false

func _ready() -> void:
	DialogueManager.dialogue_ended.connect(_on_dialogue_ended)

func _unhandled_input(_event: InputEvent) -> void:
	# Handle Actionable
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		#print(dialogue_locked)
		if dialogue_locked == false:
			var actionables = actionable_finder.get_overlapping_areas() # should only detect things on Actionable Layer
			if actionables.size() > 0:
				actionables[0].action()
				dialogue_locked = true
				#get_tree().paused = true
				return
				
	# Handle jump.	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	# Get the input direction: -1, 0, 1
	input_direction = Input.get_axis("move_left", "move_right")
		

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	
	# Apply movement
	if dialogue_locked:
		input_direction = 0
		velocity.x = 0
	else:
		if input_direction:
			velocity.x = move_toward(velocity.x, input_direction * MAX_SPEED, ACCEL * delta)
		else:
			velocity.x = move_toward(velocity.x, 0, DECEL * delta)

	move_and_slide()
	update_animations(input_direction)
	
func update_animations(input_direction):
	# Flip the Sprite
	if input_direction > 0:
		animated_sprite.flip_h = false
		direction_marker.rotation_degrees = 0.0
	elif input_direction < 0:
		animated_sprite.flip_h = true
		direction_marker.rotation_degrees = 180.0
	
	# Play animations
	if is_on_floor():
		if input_direction == 0:
			animated_sprite.play("idle")
		else:
			animated_sprite.play("run")
	else:
		animated_sprite.play("jump")
		
func _on_dialogue_ended(resource: DialogueResource):
	dialogue_locked = false
	
func take_damage():
	pass

func DIE(): # rip
	is_dead = true
	print("You died")
	self.get_node("CollisionShape2D").queue_free()
	after_death_timer.start()

func _on_after_death_timer_timeout() -> void:
	get_tree().reload_current_scene()
