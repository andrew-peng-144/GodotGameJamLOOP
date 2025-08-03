extends Area2D
@onready var checkpointSprite: AnimatedSprite2D = $AnimatedSprite2D
var lit = false


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		if lit == false:
			AudioManager.torch_lit.play()
			lit = true
		if checkpointSprite:
			checkpointSprite.play(&"lit")
		Globals.current_checkpoint_scene_path = get_tree().current_scene.scene_file_path
		Globals.current_checkpoint_position = self.position
		print("Checkpoint saved")
