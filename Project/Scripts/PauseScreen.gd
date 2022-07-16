extends Control


onready var resume_button: Button = $"CenterContainer/VBoxContainer/Buttons/Resume"
onready var tree: SceneTree = get_tree()
onready var scrub: ScrubPlayer = tree.current_scene.get_node("Scrub")


func _input(event: InputEvent) -> void:
	if not event.is_action_pressed("Pause"):
		return
	tree.set_input_as_handled()
	
	if not tree.paused:
		resume_button.grab_focus()
	
	# Scrub never pauses, except here, so change the pause mode
	if scrub:
		scrub.pause_mode = PAUSE_MODE_STOP
	
	tree.paused = true
	show()


func _on_Resume_pressed() -> void:
	if scrub:
		scrub.pause_mode = PAUSE_MODE_PROCESS
	tree.paused = false
	hide()


func _on_Quit_pressed() -> void:
	tree.quit()


func _on_MainMenu_pressed() -> void:
	var scene_changed: int = tree.change_scene("res://Scenes/MainMenu.tscn")
	assert(scene_changed == OK, "Main Menu scene not found at given path")


func _on_IntensitySlider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), value)
