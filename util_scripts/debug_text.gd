extends Label

@onready var debug_text: Label = $"."
@export var player: CharacterBody2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	debug_text.text = "Player dialogue_locked: " + str(player.dialogue_locked)
