extends KinematicBody2D

var velocity = Vector2()
var is_staggered = false

enum DIRECTION {
	LEFT = -1
	RIGHT = 1
}

export(DIRECTION) var direction = -1

export var detect_cliffs := true
export var speed := 20
export var health := 2
var GRAVITY: int = 20

onready var slasher_sprites := $"AnimatedSprite"
onready var top_checker := $"TopChecker"
onready var sides_checker := $"SidesChecker"
onready var cliffs_checker := $"FloorChecker"


func _ready():
	scale.x = direction * -1
	cliffs_checker.enabled = detect_cliffs


func _physics_process(_delta):
		if is_on_wall() or not cliffs_checker.is_colliding() and detect_cliffs and is_on_floor():
			direction *= -1
			scale.x *= -1
		
		velocity = Vector2(speed * direction * (not is_staggered) as int, velocity.y + GRAVITY)
		velocity = move_and_slide(velocity,Vector2.UP)


func damage(damage: int = 1):
	if !is_staggered:
		health -= damage
		
		if health <= 0:
			die()
		else:
			is_staggered = true
			modulate = Color(0.3,0.3,0.3,0.6)
			slasher_sprites.play("stagger")
			$StaggerTimer.start()


func die():
	queue_free()


func _on_TopChecker_body_entered(body):
	if body is ScrubPlayer:
		damage()
		body.velocity.y = -160


func _on_SidesChecker_body_entered(body: ScrubPlayer):
	if not is_staggered:
		body.die(true, global_position)
	else:
		body.velocity.x = (325 - 650 *
				(body.global_position.x < global_position.x) as int)


func _on_StaggerTimer_timeout():
	slasher_sprites.play("walk")
	modulate = Color.white
	is_staggered = false
