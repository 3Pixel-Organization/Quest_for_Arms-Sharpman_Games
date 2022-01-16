extends KinematicBody2D


enum DIRECTION {
	LEFT = -1
	RIGHT = 1
}

const GRAVITY = 20

export(DIRECTION) var direction: int = -1
export var detect_cliffs: bool = true
export var speed: int = 20
export var health: int = 2

var velocity: Vector2 = Vector2.ZERO
var is_staggered: bool = false

onready var slasher_sprites: AnimatedSprite = $"AnimatedSprite"
onready var top_checker: Area2D = $"TopChecker"
onready var sides_checker: Area2D = $"SidesChecker"
onready var cliffs_checker: RayCast2D = $"FloorChecker"


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
		body.die()
	else:
		body.velocity.x = (325/1.5 - 650/1.5 *
				(body.global_position.x < global_position.x) as int)


func _on_StaggerTimer_timeout():
	slasher_sprites.play("walk")
	modulate = Color.white
	is_staggered = false
