extends Control

onready var resume_button = $"CenterContainer/VBoxContainer/Buttons/Resume"
onready var quit_button = $"CenterContainer/VBoxContainer/Buttons/Quit"


func _process(_delta):
	if Input.is_action_pressed("Pause"):
		visible = true
		get_tree().paused = true


func _on_Resume_pressed():
	hide()
	get_tree().paused = false


func _on_Quit_pressed():
	get_tree().quit()


func _on_Menu_pressed():
	var scene_changed: int = get_tree().change_scene("res://Scenes/MainMenu.tscn")
	assert(scene_changed == OK, "Scene not found at given path")


func _on_HSlider_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), value)
