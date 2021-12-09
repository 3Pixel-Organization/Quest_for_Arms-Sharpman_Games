class_name Level
extends Node


export var next_scene: String
onready var scrub : ScrubPlayer = $"Scrub"


func _ready() -> void:
	assert(scrub, "where scrumble???")
	get_tree().paused = false
	
	if (GlobalVariables.checkpoint["Level"] == name):
		scrub.global_position = GlobalVariables.checkpoint["Position"]


func _on_Scrub_death() -> void:
	($"Music" as AudioStreamPlayer).stop()


func _on_EndLevelPortal_body_entered(body: ScrubPlayer) -> void:
	if not body: return
	
	GlobalVariables.player = {
		"Gun": scrub.has_fireball,
		"Coins": scrub.coins,
	}
	
	assert(get_tree().change_scene(next_scene) == OK)
