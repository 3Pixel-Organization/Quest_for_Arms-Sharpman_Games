extends Area2D

func _on_gun_picked_up(body: ScrubPlayer):
	body.fireball_pickup()
	set_deferred("monitoring", false)
	$Gun.queue_free()
	$AnimationPlayer.stop()
	$Particles2D.emitting = false
