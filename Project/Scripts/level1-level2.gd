extends VideoPlayer





func _on_VideoPlayer_finished():
	get_tree().change_scene("res://Scenes/Level2.tscn")

func _process(delta):
	if Input.is_action_pressed("ui_accept"):
		get_tree().change_scene("res://Scenes/Level2.tscn")
