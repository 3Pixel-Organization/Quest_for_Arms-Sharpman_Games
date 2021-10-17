extends VideoPlayer


func _on_VideoPlayer_finished():
	assert(get_tree().change_scene("res://Scenes/MainMenu.tscn") == OK)


func _input(_event):
	assert(get_tree().change_scene("res://Scenes/MainMenu.tscn") == OK)
