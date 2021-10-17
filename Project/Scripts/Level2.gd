extends Node

onready var scrub = $Scrub

func _init():
	GlobalVariables.player["Gun"] = true	# This is just to emulate old
											# behaviour. Might be removed
											# later


func _ready():
	get_tree().paused = false
	if GlobalVariables.checkpoint_location:
		scrub.global_position = GlobalVariables.checkpoint_location

func _on_Scrub_death():
	get_node("HUD/Node2D").visible()
	$music.stop()

