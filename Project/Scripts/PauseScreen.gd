extends Control


onready var tree: SceneTree = get_tree()


func _input(event: InputEvent) -> void:
	if not event.is_action_pressed("Pause"): return
	
	if not tree.paused:
		($"CenterContainer/VBoxContainer/Buttons/Resume" as Button).grab_focus()
	
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


func _on_MainMenu_pressed() -> void:
	var scene_changed: int = tree.change_scene("res://Scenes/MainMenu.tscn")
	assert(scene_changed == OK, "Scene not found at given path")


func _on_IntensitySlider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), value)
