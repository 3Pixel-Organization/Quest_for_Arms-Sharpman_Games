extends StaticBody2D


func _on_Area2D_body_entered(body: ScrubPlayer) -> void:
	if not body: return
	
	body.die()
