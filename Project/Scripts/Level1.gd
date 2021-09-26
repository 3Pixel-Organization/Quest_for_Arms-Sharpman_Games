extends Node

func _ready():
	get_tree().paused = false

func _on_player_death():
	$"Music".stop()
