extends Area2D

const SPEED = 100
var direction = Vector2()
var velocity = 1

func _physics_process(delta):
	
	direction.x -= SPEED * delta - velocity
	
	translate(direction)
	
	if position.x <= -1000:
		queue_free()

func _on_Area2D_body_entered(body):
	if body.name == "Scrub": 
		body._ouch()

func _on_Area2D_area_entered(area):
	if area.is_in_group("kick"):
		queue_free()
