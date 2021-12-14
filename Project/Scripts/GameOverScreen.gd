extends ColorRect

onready var restart_button = $"MarginContainer/VBoxContainer/Buttons/Restart"
onready var quit_button = $"MarginContainer/VBoxContainer/Buttons/Quit"
onready var menu_button = $"MarginContainer/VBoxContainer/Buttons/Menu"
onready var death_jingle = $"DeathJingle"
onready var timer = $"Timer"


func _on_Scrub_death(wait_time):
	get_tree().paused = true
	if wait_time:
		timer.wait_time = wait_time
		timer.start()
	else:
		_on_Timer_timeout()


func _on_Timer_timeout():
	death_jingle.play()
	visible = true


func _on_Quit_pressed():
	get_tree().quit()


func _on_Restart_pressed():
# warning-ignore:return_value_discarded
	get_tree().reload_current_scene()


func _on_Menu_pressed():
	var scene_changed: int = get_tree().change_scene("res://Scenes/MainMenu.tscn")
	assert(scene_changed == OK, "Scene not found at given path")
