extends VideoPlayer


func _on_VideoPlayer_finished():
	assert(get_tree().change_scene("res://Scenes/Level1.tscn") == OK)


func _input(event):
	if event.is_action_pressed("ui_accept"):
		assert(get_tree().change_scene("res://Scenes/Level1.tscn") == OK)
