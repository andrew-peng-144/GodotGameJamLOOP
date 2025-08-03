extends Node
@onready var newspaper_flip: AudioStreamPlayer = $"Newspaper-flip"
@onready var jump_low: AudioStreamPlayer = $"Jump-low"
@onready var jump_low_long: AudioStreamPlayer = $"Jump-low-long"
@onready var coin_drop: AudioStreamPlayer = $"Coin-drop"
@onready var paper_crumble: AudioStreamPlayer = $"Paper-crumble"
@onready var planting: AudioStreamPlayer = $Planting
@onready var watering: AudioStreamPlayer = $Watering
@onready var cup_put_down: AudioStreamPlayer = $"Cup-put-down"
@onready var gulp: AudioStreamPlayer = $Gulp
@onready var rustle: AudioStreamPlayer = $Rustle
@onready var cloak: AudioStreamPlayer = $Cloak
@onready var unlock: AudioStreamPlayer = $Unlock
@onready var glint: AudioStreamPlayer = $Sparkle
@onready var hit: AudioStreamPlayer = $Hit3
@onready var spellcasting: AudioStreamPlayer = $"Magic-spell-333896"
@onready var explosions: AudioStreamPlayer = $"Explosion-large-129051"
@onready var torch_lit: AudioStreamPlayer = $"Torch-lit"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
