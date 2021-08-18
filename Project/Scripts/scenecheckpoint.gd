extends Area2D

func _ready():
	pass

func _on_Area2D_body_entered(_body):
	Checkpoint.laast_location = global_position
