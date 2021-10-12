extends Area2D # Must be upgraded to a RigidBody2D

var cooldowninaction = false
var velocity = Vector2()


func _ready():
	if not velocity.x:
		queue_free()
	$Sprite.flip_h = velocity.x < 0


func _physics_process(delta):
	global_translate(velocity * delta)


func desintegrate():
	queue_free()


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()


func _on_Fireball_body_entered(body: Node2D):
	if body.has_method("damage"):
		body.damage()
	
	desintegrate()
