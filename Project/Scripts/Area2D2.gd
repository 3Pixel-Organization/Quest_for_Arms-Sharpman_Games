extends Area2D

func _on_Area2D2_body_entered(body):
	if body.name == "Scrub":
# warning-ignore:return_value_discarded
		get_tree().change_scene("res://Scenes/level1-level2.tscn")
