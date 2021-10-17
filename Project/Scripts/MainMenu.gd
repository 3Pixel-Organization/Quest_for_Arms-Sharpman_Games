extends TextureRect


func _on_Start_pressed():
	assert(get_tree().change_scene("res://Scenes/intro.tscn") == OK)


func _on_About3Pixel_pressed():
	assert(OS.shell_open("https://3-pixel.com/") == OK)


func _on_Quit_pressed():
	get_tree().quit()


func _on_IntensitySlider_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), value)
