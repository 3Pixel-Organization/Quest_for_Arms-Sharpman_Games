extends Area2D


onready var level: Node = get_tree().current_scene


func _ready() -> void:
	if (GlobalVariables.checkpoint["Level"] == level.name and
			get_index() <= GlobalVariables.checkpoint["Index"]):
		return
	
	var checkpoint_ready: int = connect("body_entered", self,
			"_on_Area2D_body_entered", [], CONNECT_ONESHOT)
			# The signal in oneshot because the checkpoint
			# shouldn't trigger more than once
	
	assert(checkpoint_ready == OK, "Checkpoint collision signal couldn't connect")


func _on_Area2D_body_entered(body: ScrubPlayer) -> void:
	if not body:
		return
	
	GlobalVariables.checkpoint = {
		"Level": level.name,
		"Position": global_position,
		"Index": get_index(),
	}
	
	GlobalVariables.player = {
		"Gun": level.scrub.has_fireball,
		"Coins": level.scrub.coins,
	}
