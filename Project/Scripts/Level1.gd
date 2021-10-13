extends Node

func _ready():
	get_tree().paused = false


func _on_player_death():
	$"Music".stop()


func _on_EndLevelPortal_body_entered(body):
	if body is ScrubPlayer:
# warning-ignore:return_value_discarded
		get_tree().change_scene("res://Scenes/level1-level2.tscn")
