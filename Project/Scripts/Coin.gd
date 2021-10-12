extends Area2D

# Coin collection
func _on_Coin_body_entered(body: ScrubPlayer):
	body.coins += 1
	$AnimationPlayer.play("Bounce")
	set_deferred("monitoring", false)
	$Sound.play()

func _on_Sound_finished():
	queue_free()
