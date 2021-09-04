extends Area2D

const SPEED = 30
var velocity = Vector2() ## should be set by generator

func _physics_process(delta):
	if not $VisibilityNotifier2D.is_on_screen():
		queue_free()
	translate(velocity)

func _on_Area2D_body_entered(body):
	if body.name == "Scrub": 
		body.ouch(global_position.x)

func _on_Area2D_area_entered(area):
	if area.is_in_group("kick"):
		queue_free()

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
