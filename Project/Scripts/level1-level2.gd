extends VideoPlayer





func _on_VideoPlayer_finished():
	get_tree().change_scene("res://Scenes/Level2.tscn")
