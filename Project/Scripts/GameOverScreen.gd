extends ColorRect


onready var tree: SceneTree = get_tree()
onready var scrub: ScrubPlayer = tree.current_scene.get_node("Scrub")
onready var restart_button: Button = $"MarginContainer/VBoxContainer/Buttons/Restart"
onready var quit_button: Button = $"MarginContainer/VBoxContainer/Buttons/Quit"
onready var menu_button: Button = $"MarginContainer/VBoxContainer/Buttons/Menu"
onready var death_jingle: AudioStreamPlayer = $"DeathJingle"
onready var timer: Timer = $"Timer"
onready var pause_screen: Control = get_node_or_null("../PauseScreen")


func _on_Scrub_death(wait_time: float) -> void:
	pause_screen.pause_mode = PAUSE_MODE_STOP
	tree.paused = true
	if wait_time:
		timer.start(wait_time)
	else:
		_on_Timer_timeout()


func _on_Timer_timeout() -> void:
	scrub.pause_mode = PAUSE_MODE_INHERIT # So scrub doesn't process indefinetly
	restart_button.grab_focus()
	death_jingle.play()
	show()


func _on_Quit_pressed() -> void:
	tree.quit()


func _on_Restart_pressed() -> void:
	var scene_reloaded := tree.reload_current_scene() as int
	assert(scene_reloaded == OK, "Level could not be reloaded")


func _on_Menu_pressed() -> void:
	var scene_changed: int = tree.change_scene("res://Scenes/MainMenu.tscn")
	assert(scene_changed == OK, "Scene not found at given path")
