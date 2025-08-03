extends Area2D

class_name Wizard

@export var health = 3

@onready var killzone: Area2D = $Killzone
@onready var top_area: Area2D = $TopArea

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var invulnerability_shield: AnimatedSprite2D = $InvulnerabilityShield

@export var player_body: CharacterBody2D
@export var bounce = 300

var invuln = true
var invuln_seconds = 1.0

var tween: Tween

var dead = false

func _ready():
	pass
	tween = create_tween().set_loops()

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
	
func teleport_to(pos: Vector2):
	animated_sprite_2d.play("teleport")
	await animated_sprite_2d.animation_finished
	self.position = pos
	animated_sprite_2d.play("teleport")
	await animated_sprite_2d.animation_finished
	animated_sprite_2d.play("idle")
	
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
			body.make_invuln(0.2)
			self.make_invuln(invuln_seconds)
			animated_sprite_2d.play("hurt")
			await animated_sprite_2d.animation_finished
			if health <= 0:
				die()
			
		
