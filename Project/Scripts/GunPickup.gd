extends Area2D

func _on_gun_picked_up(body):
	if body.name == "Scrub":
		body.fireball_pickup()
		$Gun.queue_free()
		$CollisionShape2D.queue_free()
		$AnimationPlayer.stop()
		$Particles2D.emitting = false
