extends Area2D

signal coin_collected

#Collect Coin Code
func _on_Area2D_body_entered(body):
	$AudioStreamPlayer.play()
	$AnimationPlayer.play("bounce")
	emit_signal("coin_collected")
	set_collision_layer_bit(0,false)


func _on_AnimationPlayer_animation_finished(anim_name):
	$Timer.start()



func _on_Timer_timeout():
	queue_free()
