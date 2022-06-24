extends Area2D


onready var activation_area: Area2D = $"."
onready var collision_body: StaticBody2D = $"StaticBody2D"


func _on_Door_body_entered(body: ScrubPlayer) -> void:
	collision_body.position.y -= 48


func _on_Door_body_exited(body: ScrubPlayer) -> void:
	collision_body.position.y += 48
