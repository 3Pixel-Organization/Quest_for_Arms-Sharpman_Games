extends KinematicBody2D 

func _on_FallTimer_timeout():
	$AnimationPlayer.play("Fall")
	$CollisionShape2D.disabled = true

func _on_AnimationPlayer_animation_finished(_anim_name):
	queue_free()

func _on_TopChecker_body_entered(body):
	if body.name == "Scrub":
		$TopChecker/CollisionShape2D.disabled = true
		$AnimationPlayer.play("Shake")
		$FallTimer.start()
