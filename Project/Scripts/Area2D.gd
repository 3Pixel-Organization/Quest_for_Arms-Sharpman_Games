extends Area2D

signal coin_collected

## Coin collection
func _on_Area2D_body_entered(body):
	if body.name == "Scrub":
		$AnimationPlayer.play("bounce")
		emit_signal("coin_collected")
		set_collision_layer_bit(0,false)
		body.play_sound()

func _on_AnimationPlayer_animation_finished(_anim_name):
	queue_free()
