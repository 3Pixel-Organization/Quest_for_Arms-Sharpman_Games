extends TextureRect


onready var tree: SceneTree = get_tree()
onready var start_button: Button = $"VBoxContainer/Start"

func _ready() -> void:
	start_button.grab_focus()
	tree.paused = false


func _on_Start_pressed() -> void:
	var scene_chagend: int = tree.change_scene("res://Scenes/Intro.tscn")
	assert(scene_chagend == OK, "Scene could not be loaded")


func _on_About3Pixel_pressed() -> void:
	var website_opened: int = OS.shell_open("https://3-pixel.com/")
	assert(website_opened == OK)


func _on_Quit_pressed() -> void:
	tree.quit()


func _on_IntensitySlider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), value)


func _on_Tutorial_pressed():
	var scene_chagend: int = tree.change_scene("res://Scenes/Tutorial.tscn")
	assert(scene_chagend == OK, "Scene could not be loaded")
