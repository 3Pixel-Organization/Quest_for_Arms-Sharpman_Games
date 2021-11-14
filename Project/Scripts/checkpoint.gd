extends Area2D
class_name CheckpointArea

func _ready():
	assert(connect("body_entered", self, "_on_Area2D_body_entered") == OK, "Checkpoint not working")

func _on_Area2D_body_entered(_body):
	GlobalVariables.checkpoint_location = global_position
