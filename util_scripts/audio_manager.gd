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

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
