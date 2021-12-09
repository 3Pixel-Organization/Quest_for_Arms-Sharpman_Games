extends VideoPlayer

export var scene_path : String


func _on_VideoPlayer_finished():
	assert(get_tree().change_scene(scene_path) == OK)


func _input(event):
	if event.is_action_pressed("ui_accept"):
		var scene_changed: int = get_tree().change_scene(scene_path)
		assert(scene_changed == OK, "Scene not found at given path")
