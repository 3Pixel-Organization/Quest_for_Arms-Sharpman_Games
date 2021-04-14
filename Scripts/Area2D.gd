extends Area2D

signal coin_collected

#Collect Coin Code
func _on_Area2D_body_entered(body):
	$AnimationPlayer.play("bounce")
	emit_signal("coin_collected")
	set_collision_layer_bit(0,false)


func _on_AnimationPlayer_animation_finished(anim_name):
	queue_free()
