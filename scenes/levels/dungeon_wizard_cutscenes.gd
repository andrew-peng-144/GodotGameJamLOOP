extends Node
@onready var wizard: CharacterBody2D = %Wizard
@onready var wizardSprite = wizard.get_node("AnimatedSprite2D")
@onready var area_2d: Area2D = $"../Wizard/Area2D"

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
		wizardSprite.play(&"reveal_idle")
		print("Third time in wizard's dungeon.")
	else:
		print("Loop count isn't 0, 1, or 2...?")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
