extends Control


onready var resume_button: Button = $"CenterContainer/VBoxContainer/Buttons/Resume"
onready var quit_button: Button = $"CenterContainer/VBoxContainer/Buttons/Quit"
onready var tree: SceneTree = get_tree()

func _input(event: InputEvent) -> void:
	if not event.is_action_pressed("Pause"): return

	visible = true
	pause_mode = PAUSE_MODE_PROCESS
	tree.paused = true
	tree.set_input_as_handled()


func _on_Resume_pressed() -> void:
	visible = false
	pause_mode = PAUSE_MODE_STOP
	tree.paused = false


func _on_Quit_pressed() -> void:
	tree.quit()


func _on_Menu_pressed() -> void:
	var scene_changed: int = tree.change_scene("res://Scenes/MainMenu.tscn")
	assert(scene_changed == OK, "Scene not found at given path")


func _on_HSlider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), value)
