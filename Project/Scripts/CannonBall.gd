extends KinematicBody2D


var velocity: Vector2 # Should be set by instanciator


func _ready() -> void:
	if not velocity:
		queue_free()


func _physics_process(delta) -> void:
	var collisionData: KinematicCollision2D = move_and_collide(velocity * delta)
	if collisionData:
		var collider := collisionData.collider as ScrubPlayer
		if collider: collider.die()
		desintegrate()


func desintegrate() -> void:
	velocity = Vector2.ZERO
	set_deferred("CollisionObject2D:disabled", true)
	queue_free()


func _on_VisibilityNotifier2D_screen_exited() -> void:
	queue_free()
