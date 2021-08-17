extends KinematicBody2D
var iscrumbling = false 

func _ready():
	pass

func _on_Timer_timeout():
	$AnimationPlayer.play("New Anim")

func _on_AnimationPlayer_animation_finished(anim_name):
	iscrumbling = false
	queue_free()

func _on_Area2D_body_entered(body):
	if body.name == "Scrub" && !iscrumbling:
		iscrumbling = true
		$AnimationPlayer2.play("New Anim")
		$Timer.start()
