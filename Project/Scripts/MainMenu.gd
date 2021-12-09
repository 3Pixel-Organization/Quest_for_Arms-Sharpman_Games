extends TextureRect


func _ready():
	get_tree().paused = false


func _on_Start_pressed():
	var scene_chagend: int = get_tree().change_scene("res://Scenes/intro.tscn")
	assert(scene_chagend == OK, "Scene not found at given path")


func _on_About3Pixel_pressed():
	var website_opened: int = OS.shell_open("https://3-pixel.com/")
	assert(website_opened == OK)


func _on_Quit_pressed():
	get_tree().quit()


func _on_IntensitySlider_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), value)
