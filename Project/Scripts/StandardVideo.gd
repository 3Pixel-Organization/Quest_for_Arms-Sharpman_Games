extends VideoPlayer


export var scene_path: String

onready var tree: SceneTree = get_tree()


func _on_VideoPlayer_finished() -> void:
	var scene_changed: int = tree.change_scene(scene_path)
	assert(scene_changed == OK)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept") or event is InputEventMouseButton:
		var scene_changed: int = tree.change_scene(scene_path)
		assert(scene_changed == OK, "Scene could not be loaded")
