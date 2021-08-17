extends Node2D

func _on_Scrub_death():
	get_node("HUD/Node2D").visible()
	$AudioStreamPlayer.stop()

func _on_Area2D2_body_entered(body):
	if body.name == "Scrub":
		body.fireball_pickup()

func _enter_tree():
	if Checkpoint.laast_location:
		$Scrub.global_position = Checkpoint.laast_location
