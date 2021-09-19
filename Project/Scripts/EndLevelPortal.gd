extends Area2D

func _on_EndLevel_body_entered(body):
	if body is ScrubPlayer:
# warning-ignore:return_value_discarded
		get_tree().change_scene("res://Scenes/level1-level2.tscn")
