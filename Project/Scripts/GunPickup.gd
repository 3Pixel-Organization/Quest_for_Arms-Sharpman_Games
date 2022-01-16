extends Area2D

func _on_gun_picked_up(body: ScrubPlayer) -> void:
	if not body: return
	
	body.fireball_pickup()
	set_deferred("monitoring", false)
	($"Gun" as Sprite).queue_free()
	($"AnimationPlayer" as AnimationPlayer).stop()
	($"Particles2D" as Particles2D).emitting = false
