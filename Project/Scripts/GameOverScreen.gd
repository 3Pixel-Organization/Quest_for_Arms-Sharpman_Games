extends ColorRect

onready var restart_button = $"MarginContainer/VBoxContainer/Buttons/Restart"
onready var quit_button = $"MarginContainer/VBoxContainer/Buttons/Quit"
onready var menu_button = $"MarginContainer/VBoxContainer/Buttons/Menu"
onready var death_jingle = $"DeathJingle"


func _on_Scrub_death():
	visible = true
	death_jingle.play()


func _on_Quit_pressed():
	get_tree().quit()


func _on_Restart_pressed():
# warning-ignore:return_value_discarded
	get_tree().reload_current_scene()


func _on_Menu_pressed():
	get_tree().change_scene("res://Scenes/MainMenu.tscn")
