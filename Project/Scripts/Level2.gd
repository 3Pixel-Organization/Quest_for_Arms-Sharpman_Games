extends Node2D


func _on_Scrub_death():
	get_node("HUD/Node2D").visible()
	$AudioStreamPlayer.stop()


func _on_Area2D2_body_entered(body):
	if body.name == "Scrub":
		body.fireball_pickup()
