extends Control

func _ready():
	pass

func _on_Button2_pressed():
# warning-ignore:return_value_discarded
	OS.shell_open("https://3-pixel.com/")

func _on_Button3_pressed():
	get_tree().quit()

func _on_Button_pressed():
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Scenes/intro.tscn")

func _on_HSlider_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), value)
