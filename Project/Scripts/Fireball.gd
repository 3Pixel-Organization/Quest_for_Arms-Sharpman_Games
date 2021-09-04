extends Area2D

var cooldowninaction = false
var velocity = Vector2()

func _ready():
	if velocity.x == 0:
		queue_free()
	$Sprite.flip_h = velocity.x < 0

func _physics_process(delta):
	translate(velocity)

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

func _on_Fireball_body_entered(body):
	if "enemy" in body.name:
			body.fireball_dead()
			queue_free()
