extends TextureRect


func _ready() -> void:
	($"VBoxContainer/Start" as Button).grab_focus()
	get_tree().paused = false


func _on_Start_pressed() -> void:
	var scene_chagend: int = get_tree().change_scene("res://Scenes/Intro.tscn")
	assert(scene_chagend == OK, "Scene not found at given path")


func _on_About3Pixel_pressed() -> void:
	var website_opened: int = OS.shell_open("https://3-pixel.com/")
	assert(website_opened == OK)


func _on_Quit_pressed() -> void:
	get_tree().quit()


func _on_IntensitySlider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), value)


func _on_TutorialButton_pressed():
	var scene_chagend: int = get_tree().change_scene("res://Scenes/Tutorial.tscn")
	assert(scene_chagend == OK, "Scene not found at given path")
