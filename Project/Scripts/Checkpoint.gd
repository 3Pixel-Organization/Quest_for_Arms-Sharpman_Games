extends Area2D
class_name CheckpointArea


onready var level: Node = get_tree().current_scene
onready var activated: bool = (GlobalVariables.checkpoint["Level"] == get_tree().current_scene.name
		and get_index() <= GlobalVariables.checkpoint["Highest"])


func _ready() -> void:
	if not activated:
		var checkpoint_ready: int = connect("body_entered", self,
				"_on_Area2D_body_entered", [], CONNECT_ONESHOT)
				# Oneshot should be removed if the checkpoint checks for 
				# things other than the player

		assert(checkpoint_ready == OK, "Checkpoint not working")


func _on_Area2D_body_entered(body: ScrubPlayer) -> void:
	if not body: return
	activated = true
	#disconnect("body_entered", self, "_on_Area2D_body_entered")
	# ^ is only needed if the checkpoint doesnt collide only with the player

	GlobalVariables.checkpoint = {
		"Level": level.name,
		"Position": global_position,
		"Highest": max(get_index(), GlobalVariables.checkpoint["Highest"]),
	}
	
	GlobalVariables.player = {
		"Gun": level.scrub.has_fireball,
		"Coins": level.scrub.coins,
	}
