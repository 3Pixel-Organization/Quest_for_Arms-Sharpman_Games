extends Node

onready var scrub = $Scrub

func _ready():
	if scrub.has_method("fireball_pickup") && !scrub.has_fireball:
		scrub.fireball_pickup()

func _on_Scrub_death():
	get_node("HUD/Node2D").visible()
	$music.stop()

func _enter_tree():
	if Checkpoint.laast_location:
		$Scrub.global_position = Checkpoint.laast_location
