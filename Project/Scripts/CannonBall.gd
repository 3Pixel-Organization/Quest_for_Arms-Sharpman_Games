extends KinematicBody2D


var velocity: Vector2 # Should be set by instanciator
var spawner: Node

onready var sprite: Sprite = $"Sprite"


func _ready() -> void:
	assert(spawner)
	if not velocity:
		queue_free()
	else:
		sprite.flip_h = velocity.x > 0


func _physics_process(delta) -> void:
	var collisionData := move_and_collide(velocity * delta) as KinematicCollision2D
	if collisionData:
		if collisionData.collider is ScrubPlayer:
			collisionData.collider.die()
		if collisionData.collider != spawner:
			desintegrate()


func desintegrate() -> void:
	velocity = Vector2.ZERO
	set_deferred("CollisionObject2D:disabled", true)
	queue_free()


func _on_VisibilityNotifier2D_screen_exited() -> void:
	queue_free()
