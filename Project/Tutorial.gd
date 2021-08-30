extends Node2D

func ready():
	pass

func _on_StartGame_body_entered(body):
	if body.name == "Scrub":
		get_tree().change_scene("res://Scenes/intro.tscn")


func _on_Area2D2_body_entered(body):
	if body.name == "Scrub":
		body.candiefalse()
