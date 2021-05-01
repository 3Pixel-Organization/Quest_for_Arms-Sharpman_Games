extends Node2D


func _on_Scrub_death():
	get_node("HUD/Node2D").visible()
	$AudioStreamPlayer.stop()
