extends Area2D

# Coin collection
func _on_Coin_body_entered(body):
	if body is ScrubPlayer:
		body.coins += 1
		$AnimationPlayer.play("Bounce")
		set_collision_layer_bit(0,false)
		$Sound.play()

func _on_Sound_finished():
	queue_free()
