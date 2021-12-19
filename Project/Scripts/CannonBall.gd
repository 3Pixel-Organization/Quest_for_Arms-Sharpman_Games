extends Area2D

var velocity = Vector2() # Should be set by instanciator


func _ready():
	if not velocity:
		queue_free()


func _physics_process(delta):
	global_translate(velocity * delta)


func desintegrate():
	velocity = Vector2.ZERO
	queue_free()


func _on_Area2D_body_entered(body):
	if body is ScrubPlayer:
		body.die()
	
	desintegrate()


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
