extends Node2D

func ready():
	pass

func _on_StartGame_body_entered(body):
	if body.name == "Scrub":
		get_tree().change_scene("res://Scenes/intro.tscn")
