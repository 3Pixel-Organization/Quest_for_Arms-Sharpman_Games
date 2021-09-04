extends Node2D

onready var Scrub = $Scrub

func ready():
	Scrub.candie = false

func _on_StartGame_body_entered(body):
	if body.name == "Scrub":
		get_tree().change_scene("res://Scenes/intro.tscn")
