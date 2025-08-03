extends CharacterBody2D

class_name Player

const ACCEL = 800.0
const DECEL = 1000.0
const ACCEL_AIR = 400.0
const DECEL_AIR = 200.0
const JUMP_VELOCITY = -370.0
const MIDAIR_JUMP_SPEED = 450.0
#const JUMP_VELOCITY_1 = -260.0
#const JUMP_VELOCITY_2 = -360.0
#const JUMP_VELOCITY_3 = -440.0
const MAX_SPEED = 130.0
const MAX_SPEED_AIR = 130.0
const SHORT_HOP_RATIO = 0.75

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var actionable_finder: Area2D = $DirectionMarker/ActionableFinder
@onready var direction_marker: Marker2D = $DirectionMarker
@onready var after_death_timer: Timer = $AfterDeathTimer
@onready var camera_2d: Camera2D = $Camera2D
@onready var killzone_sensor: Area2D = $KillzoneSensor
@onready var trigger_sensor: Area2D = $TriggerSensor
@onready var screen_transition_animation_player: Node = $ScreenTransitionAnimation/AnimationPlayer
@onready var screen_transition_animation_color_rect: ColorRect = $ScreenTransitionAnimation/ColorRect


var input_direction: int = 0

var dialogue_locked = false
var is_dead = false
var is_stopped = false

#var triple_jump_progress = 0 # 1, 2, or 3. 0 is invalid.

var max_midair_jumps = 3
var midair_jumps_remaining = 0




func _ready() -> void:
	DialogueManager.dialogue_ended.connect(_on_dialogue_ended)
	
	screen_transition_animation_color_rect.visible = true # so it's invisible only in editor.
	screen_transition_animation_player.play("fade_out")
	
	# Move to previous checkpoint
	if (Globals.last_scene_transition_from_death):
		global_position = Globals.current_checkpoint_position

func _unhandled_input(_event: InputEvent) -> void:
	if Globals.freeze_player_input or is_stopped:
		velocity.x = 0
		velocity.y = 0
		return
		
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		if dialogue_locked == false:
			# Handle Actionable
			var actionables = actionable_finder.get_overlapping_areas() # should only detect things on Actionable Layer
			if actionables.size() > 0:
				actionables[0].action()
				dialogue_locked = true
				#get_tree().paused = true
				return
				
	# Handle jump.	
	if is_on_floor():
		midair_jumps_remaining = max_midair_jumps
	if Input.is_action_just_pressed("jump") and is_on_floor():
		# Handle door, activated on jump
		var triggers = trigger_sensor.get_overlapping_areas()
		if triggers.size() > 0:
			print(triggers)
			if triggers[0] is Door:
				Globals.last_scene_transition_from_death = false
				change_scene(triggers[0].next_scene_file)
		else:
			AudioManager.jump_low.play()
			velocity.y = JUMP_VELOCITY
			#triple_jump_progress+=1
			#if (triple_jump_progress > 3):
				#triple_jump_progress = 1
			#print("TRIPLE JUMP "+str(triple_jump_progress))
			#match triple_jump_progress:
				#1:
					#velocity.y = JUMP_VELOCITY_1
				#2:
					#velocity.y = JUMP_VELOCITY_2
				#_:
					#velocity.y = JUMP_VELOCITY_3
	elif Input.is_action_just_pressed("jump") and not is_on_floor():
		if midair_jumps_remaining > 0:
			AudioManager.jump_low.play()
			#velocity.x = 0.707 * MIDAIR_JUMP_SPEED * (-1 if animated_sprite.flip_h else 1)
			velocity.y = -0.707 * MIDAIR_JUMP_SPEED
			midair_jumps_remaining -= 1
			input_direction = 0
		
	# Get the input direction: -1, 0, 1
	input_direction = Input.get_axis("move_left", "move_right")

func _process(delta: float):
	GlobalUI.set_debug_text("Current Scene",get_tree().current_scene.scene_file_path)
	
	GlobalUI.set_debug_text("player.midair_jumps_remaining", str(midair_jumps_remaining))
	GlobalUI.set_debug_text("player.dialogue_locked", str(dialogue_locked))
	
	GlobalUI.set_debug_text("freeze_player_input", str(Globals.freeze_player_input))
	GlobalUI.set_debug_text("coins", str(Globals.coins))
	GlobalUI.set_debug_text("current_checkpoint_position", str(Globals.current_checkpoint_position))
	GlobalUI.set_debug_text("current_checkpoint_scene_path", str(Globals.current_checkpoint_scene_path))

	
func _physics_process(delta: float) -> void:
	if is_stopped:
		velocity.x = 0
		velocity.y = 0
		return

	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	
	# Apply movement
	if dialogue_locked:
		input_direction = 0
		velocity.x = 0
	else:
		if is_on_floor():
			if input_direction:
				velocity.x = move_toward(velocity.x, input_direction * MAX_SPEED, ACCEL * delta)
			else:
				velocity.x = move_toward(velocity.x, 0, DECEL * delta)
		else:
			if input_direction:
				velocity.x = move_toward(velocity.x, input_direction * MAX_SPEED_AIR, ACCEL_AIR * delta)
			else:
				velocity.x = move_toward(velocity.x, 0, DECEL_AIR * delta)

	# Release jump early for short hop	
	if Input.is_action_just_released("jump") and velocity.y < 0:
		velocity.y = velocity.y * SHORT_HOP_RATIO
		

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
	if Globals.watering == false:
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
func stop():
	is_stopped = true

func DIE(): # rip
	is_dead = true
	print("You died")
	self.get_node("CollisionShape2D").queue_free()
	killzone_sensor.queue_free()
	after_death_timer.start()
	
func change_scene(next_scene_file: String):
	screen_transition_animation_player.play("fade_in")
	is_stopped = true
	await screen_transition_animation_player.animation_finished
	get_tree().change_scene_to_file(next_scene_file)
	is_stopped = false
	

func _on_after_death_timer_timeout() -> void:
	if Globals.current_checkpoint_scene_path:
		# Change scene to prev checkpoint 
		Globals.last_scene_transition_from_death = true
		change_scene(Globals.current_checkpoint_scene_path)
	else:
		# No checkpoint
		get_tree().reload_current_scene()
	

# when player steps into any trigger zones.
func _on_trigger_sensor_area_shape_entered(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	if area is SceneTransitionArea:
		change_scene(area.next_scene_file)

# when player steps into any killzones
func _on_killzone_sensor_area_shape_entered(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	if area.is_in_group("killzones"):
		DIE()
