extends Area2D



func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		Globals.current_checkpoint_scene_path = get_tree().current_scene.scene_file_path
		Globals.current_checkpoint_position = self.position
		print("Checkpoint saved:")
