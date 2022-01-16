extends Area2D


export var JUMPSPEED: int = 200


func _on_Jumppad_body_entered(body: ScrubPlayer) -> void:
	if not body: return
	
	body.set_deferred("velocity", Vector2(body.velocity.x, -JUMPSPEED))
