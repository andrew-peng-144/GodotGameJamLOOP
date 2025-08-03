extends Node

@export var wizard_health: int = 3
@export var player: Player

@onready var area_2d: Area2D = $"../Wizard/Area2D"
@onready var door: Door = $"../Door"

# arena markers
@onready var left_beam_origin: Node2D = $Markers/LeftBeamOrigin
@onready var right_beam_origin: Node2D = $Markers/RightBeamOrigin
@onready var ground_floor_beam_origin: Node2D = $Markers/GroundFloorBeamOrigin
@onready var floor_2_beam_origin: Node2D = $Markers/Floor2BeamOrigin
@onready var floor_3_beam_origin: Node2D = $Markers/Floor3BeamOrigin
@onready var floor_4_beam_origin: Node2D = $Markers/Floor4BeamOrigin
@onready var floor_2_left_1: Node2D = $Markers/Floor2Left1
@onready var floor_2_left_2: Node2D = $Markers/Floor2Left2
@onready var floor_2_mid: Node2D = $Markers/Floor2Mid
@onready var floor_2_right_1: Node2D = $Markers/Floor2Right1
@onready var floor_2_right_2: Node2D = $Markers/Floor2Right2
@onready var floor_3_mid: Node2D = $Markers/Floor3Mid
@onready var floor_4_left: Node2D = $Markers/Floor4Left
@onready var floor_4_right: Node2D = $Markers/Floor4Right

@onready var wizard: Wizard = %Wizard
@onready var wizard_actionable_collision_shape: CollisionShape2D = $"../Wizard/Area2D/CollisionShape2D"

@onready var wizard_kill_dialogue: Actionable = %wizardKillDialogue

# preloaded spell scenes
const MOVING_SPELL_1 = preload("res://scenes/triggers/moving_spell_1.tscn")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#Globals.loop_count = 2; #REMOVE THIS!!!
	if Globals.loop_count == 0:
		print("First time in wizard's dungeon.")
	elif Globals.loop_count == 1:
		area_2d.dialogue_start = "wizard2"
		print("Second time in wizard's dungeon.")
	elif Globals.loop_count == 2:
		# wizard starts dehooded
		area_2d.dialogue_start = "wizardFinal"
		await get_tree().create_timer(0.1).timeout
		if wizard.get_node("AnimatedSprite2D"):
			wizard.get_node("AnimatedSprite2D").play(&"reveal_idle")
		print("Third time in wizard's dungeon.")
	else:
		print("Loop count isn't 0, 1, or 2...?")
		
	print("WIZARD: "+str(wizard))
	#wizard.set_friendly(true)
	player.invuln = true
	wizard.invuln = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if wizard.dead and Globals.loop_count == 0:
		wizard_kill_dialogue.onWizardDeath1()
		wizard.dead = false
	
func start_fight_1() -> void:
	print("BATTLE WITH WIZARD 1 STARTED!")
	# TODO change music
	
	player.invuln = false
	# disable door
	door.collision_shape_2d.disabled = true
	
	# disable speech bubble and dialogue
	wizard_actionable_collision_shape.disabled = true
	
	#wizard.set_friendly(false)
	wizard.set_invuln(false)
	
	# teleport to mid
	wizard.teleport_to(floor_2_mid.position)
	
	# wait random, summon spells on random rows, columns
	await get_tree().create_timer( [1.5,2.0,2.5].pick_random() ).timeout
	

	# shoot spell relative to itself: horizontal spells, or vertical spells, or diagonal
	var projectile = MOVING_SPELL_1.instantiate()
	projectile.global_position = floor_2_beam_origin.position
	projectile.direction_degrees = 0
	projectile.lifetime_seconds = 5
	projectile.speed = 100
	get_tree().current_scene.add_child(projectile)

	await get_tree().create_timer( [1.5,2.0,2.5].pick_random() ).timeout
	
	# teleport to random platform
	var random_platform = [floor_3_mid, floor_2_left_1, floor_2_right_2].pick_random()
	wizard.teleport_to(random_platform.position)
	
	# fly to top of room, invulnerable, and summons a strong storm.
	
	# etc
