class_name Level
extends Node

var AnimationPlayed = false
export var next_scene: String
onready var scrub: ScrubPlayer = $"Scrub"


func _ready() -> void:
	assert(scrub, "where scrumble???")
	get_tree().paused = false
	
	if (GlobalVariables.checkpoint["Level"] == name):
		scrub.global_position = GlobalVariables.checkpoint["Position"]


func _on_EndLevelPortal_body_entered(body: ScrubPlayer) -> void:
	if not body: return
	
	GlobalVariables.player = {
		"Gun": scrub.has_fireball,
		"Coins": scrub.coins,
	}
	
	scrub.cutscene = true
	$AnimationPlayer.play("cutscene 2")


func _on_Fallzone_body_entered(body: PhysicsBody2D) -> void:
	if body is ScrubPlayer:
		scrub.emit_signal("death", 0.5)
	else:
		body.queue_free()


func _on_CheckpointArea_body_entered(body):
	if AnimationPlayed == false:
		if body.name == "Scrub":
			$AnimationPlayer.play("cutscene")
			scrub.cutscene = true
			AnimationPlayed = true
			


func _on_AnimationPlayer_animation_finished(cutscene):
	scrub.cutscene = false


func _on_Area2D_body_entered(body):
	if AnimationPlayed == false:
		if body.name == "Scrub":
			$AnimationPlayer2.play("cutscene2")
			scrub.cutscene = true
			AnimationPlayed = true


func _on_AnimationPlayer2_animation_finished(cutscene2):
	scrub.cutscene = false


func _on_EndLevelPortal2_body_entered(body):
	var scene_chagend: int = get_tree().change_scene(next_scene)


func _on_Area2D2_body_entered(body):
	if not body: return
	
	GlobalVariables.player = {
		"Gun": scrub.has_fireball,
		"Coins": scrub.coins,
	}
	
	var scene_chagend: int = get_tree().change_scene(next_scene)
