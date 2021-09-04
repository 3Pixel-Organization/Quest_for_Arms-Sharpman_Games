extends Area2D

signal coin_collected

## Coin collection
func _on_Coin_body_entered(body):
	if body.name == "Scrub":
		$AnimationPlayer.play("Bounce")
		emit_signal("coin_collected")
		set_collision_layer_bit(0,false)
		$Sound.play()

func _on_AnimationPlayer_animation_finished(_anim_name):
	queue_free()
