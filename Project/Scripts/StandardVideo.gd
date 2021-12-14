extends VideoPlayer

export var scene_path : String


func _on_VideoPlayer_finished():
	var scene_changed = get_tree().change_scene(scene_path)
	assert(scene_changed == OK)


func _input(event):
	if event.is_action_pressed("ui_accept"):
		var scene_changed: int = get_tree().change_scene(scene_path)
		assert(scene_changed == OK, "Scene not found at given path")
