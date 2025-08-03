extends Area2D

class_name Wizard

@export var health = 3

@onready var killzone: Area2D = $Killzone
@onready var top_area: Area2D = $TopArea

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var invulnerability_shield: AnimatedSprite2D = $InvulnerabilityShield
@onready var direction_timer: Timer = $DirectionTimer

@export var player_body: CharacterBody2D
@export var bounce = 300

const MOVING_SPELL_1 = preload("res://scenes/triggers/moving_spell_1.tscn")
const MOVING_SPELL_FIREBALL = preload("res://scenes/triggers/moving_spell_fireball.tscn")

var invuln = true
var invuln_seconds = 3.0

var dead = false

var last_teleported_to = Vector2.ZERO

func _ready():
	last_teleported_to = self.position
	pass

func _process(delta: float):
	GlobalUI.set_debug_text("wizard position", str(position.x)+","+str(position.y))
	GlobalUI.set_debug_text("wizard last teleported to", str(last_teleported_to.x) + ", " + str(last_teleported_to.y) )
	GlobalUI.set_debug_text("wizard health", str(health))
	GlobalUI.set_debug_text("wizard invuln", str(invuln))

#func set_friendly(value: bool):
	#print("ASDF"+str(killzone))
	#killzone.get_node("CollisionShape2D").disabled = value


func set_invuln(value: bool):
	invuln = value
	
func make_invuln(time_in_seconds: float):
	invuln = true
	invulnerability_shield.visible = true
	#invulnerability_shield.play("default")
	await get_tree().create_timer(time_in_seconds).timeout
	#invulnerability_shield.stop()
	invulnerability_shield.visible = false
	invuln = false
	
func teleport_to(pos: Vector2, mark = true):
	if mark:
		last_teleported_to = pos
	set_invuln(true)
	animated_sprite_2d.play("teleport")
	await animated_sprite_2d.animation_finished
	self.position = pos
	animated_sprite_2d.play("teleport")
	await animated_sprite_2d.animation_finished
	animated_sprite_2d.play("idle")
	set_invuln(false)
	
func attack_random(random_positions: Array[Node2D]):
	var projectile = MOVING_SPELL_1.instantiate()
	projectile.global_position = random_positions.pick_random().position
	projectile.direction_degrees = 0
	projectile.lifetime_seconds = 5
	projectile.speed = 130
	get_tree().current_scene.add_child(projectile)
	
func shoot_fireball():
	# shoot random right or left
	var dir = [0,180].pick_random()
	var projectile = MOVING_SPELL_FIREBALL.instantiate()
	projectile.global_position = self.position
	projectile.direction_degrees = dir
	projectile.lifetime_seconds = 5
	projectile.speed = 130
	get_tree().current_scene.add_child(projectile)
	await get_tree().create_timer(0.5).timeout
	var projectile2 = MOVING_SPELL_FIREBALL.instantiate()
	projectile2.global_position = self.position
	projectile2.direction_degrees = dir
	projectile2.lifetime_seconds = 5
	projectile2.speed = 130
	get_tree().current_scene.add_child(projectile2)
	await get_tree().create_timer(0.5).timeout
	var projectile3 = MOVING_SPELL_FIREBALL.instantiate()
	projectile3.global_position = self.position
	projectile3.direction_degrees = dir
	projectile3.lifetime_seconds = 5
	projectile3.speed = 130
	get_tree().current_scene.add_child(projectile3)
	
func die():
	print("wizard ded")
	dead = true
	top_area.queue_free()
	killzone.queue_free()
	#collision_shape.disabled = true
	#animated_sprite_2d.play("death")
	#await animated_sprite_2d.animation_finished
	#print("waited.")
	#queue_free()
	
# TopArea
func _on_top_area_body_entered(body: Node2D) -> void:
	#print(body.name)
	if not invuln:
		if(body.is_in_group("player_body")):
			# deal 1 damage
			health -= 1
			print("hurt wizard, "+str(health)+" hp left")
			body.velocity.y = -bounce
			body.make_invuln(2.0)
			self.make_invuln(invuln_seconds)
			animated_sprite_2d.play("hurt")
			await animated_sprite_2d.animation_finished
			if health <= 0:
				die()
			else:
				self.teleport_to(last_teleported_to, false)
			
		
#
#
#func _on_direction_timer_timeout() -> void:
	#$DirectionTimer.wait_time = choose([1.5,2.0,2.5])
	#if !is_chasing_player:
		#direction = choose([-1.0, 1.0])
		#velocity.x = 0
