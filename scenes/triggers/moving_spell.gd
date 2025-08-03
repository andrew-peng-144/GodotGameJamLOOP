extends Area2D

@export var speed: float = 50
@export var direction_degrees: float = 0
@export var lifetime_seconds: float = 2.0

func _ready():
	get_tree().create_timer(lifetime_seconds).timeout.connect(die)

func _process(delta):
	position.x += cos(deg_to_rad(direction_degrees)) * speed * delta
	position.y += sin(deg_to_rad(direction_degrees)) * speed * delta
	
func die():
	queue_free()
