extends Area2D


func _on_area_entered(area: Area2D) -> void:
	var child_nodes = area.get_children()
	for node in child_nodes:
		#print(node.get_class())
		if node is AnimatedSprite2D and node.is_in_group("speechbubble"):
			print("aaa")
			var sprite := node as AnimatedSprite2D
			sprite.visible = true



func _on_area_exited(area: Area2D) -> void:
	var child_nodes = area.get_children()
	for node in child_nodes:
		#print(node.get_class())
		if node is AnimatedSprite2D and node.is_in_group("speechbubble"):
			print("aaa")
			var sprite := node as AnimatedSprite2D
			sprite.visible = false
