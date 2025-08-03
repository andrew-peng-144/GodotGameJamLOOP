extends Node


#var current_scene: Node = null

#func change_scene_delete(path: String) -> void:
	#get_tree().change_scene_to_file(path)
	#current_scene = 

#func change_scene_hide(path: String):
	#pass
	
#func change_scene_keep_mem(path: String):
	#if current_scene:
		#get_tree().get_root().remove_child(current_scene)
		#current_scene.queue_free()
