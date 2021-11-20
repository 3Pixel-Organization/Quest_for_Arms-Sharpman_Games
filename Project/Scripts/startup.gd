extends VideoPlayer


func _on_VideoPlayer_finished():
	assert(get_tree().change_scene("res://Scenes/MainMenu.tscn") == OK)


func _input(event):
	if Input.is_action_pressed("skip"):
		get_tree().change_scene("res://Scenes/MainMenu.tscn")
