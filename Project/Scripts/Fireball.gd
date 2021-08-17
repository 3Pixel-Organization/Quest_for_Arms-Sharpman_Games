extends Area2D

var cooldowninaction = false
var velocity = Vector2()
var direction = 1
const SPEED = 1000

func _ready():
	pass

func _set_fireball_direction(dir):
	direction = dir
	
	$Sprite.flip_h = !dir
	#if dir == -1:
	#	$Sprite.flip_h = true

func _physics_process(delta):
	velocity.x = SPEED * delta * direction
	translate(velocity)

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

func _on_Fireball_body_entered(body):
	if "enemy" in body.name:
			body.fireball_dead()
			queue_free()
