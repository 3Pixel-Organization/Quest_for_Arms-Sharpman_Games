extends Area2D
class_name CheckpointArea


onready var level_name: String = get_tree().current_scene.name

func _ready() -> void:
	assert(connect("body_entered", self, "_on_Area2D_body_entered") == OK, "Checkpoint not working")


func _on_Area2D_body_entered(_body) -> void:
	GlobalVariables.checkpoint = {
		"Level": level_name,
		"Position": global_position,
	}
