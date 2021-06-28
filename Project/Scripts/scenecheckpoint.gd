extends Area2D


func _ready():
	pass


func _on_Area2D_body_entered(body):
	Checkpoint.laast_location = global_position
