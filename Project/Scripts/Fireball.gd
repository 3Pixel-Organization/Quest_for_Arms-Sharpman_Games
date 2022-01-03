extends KinematicBody2D


var velocity = Vector2() # Must be set by instaciator


func _ready() -> void:
	if not velocity:
		queue_free()
	
	($"Sprite" as Sprite).flip_h = velocity.x < 0


func _physics_process(delta) -> void:
	var collision_data := move_and_collide(velocity * delta) as KinematicCollision2D
	if collision_data:
		var colliding_body := collision_data.collider as CollisionObject2D
		if colliding_body and colliding_body.has_method("damage"):
			colliding_body.damage()
		
		desintegrate()


func desintegrate() -> void:
	queue_free()


func _on_VisibilityNotifier2D_screen_exited() -> void:
	queue_free()
