extends Area2D


func _on_Coin_body_entered(body: ScrubPlayer) -> void:
	body.coins += 1
	($"AnimationPlayer" as AnimationPlayer).play("Bounce")
	set_deferred("monitoring", false)
	($"Sound" as AudioStreamPlayer).play()

func _on_Sound_finished() -> void:
	queue_free()
