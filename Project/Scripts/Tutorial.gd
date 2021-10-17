extends Node

onready var Scrub = $"Scrub"


func _ready():
	get_tree().paused = false
	Scrub.can_die = false


func _on_StartGame_body_entered(_body: ScrubPlayer):
	assert(get_tree().change_scene("res://Scenes/intro.tscn") == OK)
