extends Node


func _ready():
	get_tree().paused = false


func _on_player_death():
	$"Music".stop()


func _on_EndLevelPortal_body_entered(body: ScrubPlayer):
	get_tree().change_scene("res://Scenes/Level1to2.tscn")
