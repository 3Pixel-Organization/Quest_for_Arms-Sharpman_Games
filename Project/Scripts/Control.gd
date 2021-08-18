extends Control

func _process(_delta):
	if Input.is_action_pressed("Pause"):
		visible = true
		get_tree().paused = true

func _on_Button_pressed():
	hide()
	get_tree().paused = false

func _on_Button2_pressed():
	get_tree().paused = false
	get_tree().quit()

func _on_Button3_pressed():
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Scenes/MainMenu.tscn")

func _on_HSlider_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), value)
