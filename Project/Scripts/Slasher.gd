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
	slasher_sprites.flip_h = clamp(direction, 0, 1) as bool
	cliffs_checker.position.x = $CollisionShape2D.shape.extents.x * direction
	cliffs_checker.enabled = detect_cliffs


func _physics_process(_delta):
		if is_on_wall() or not cliffs_checker.is_colliding() and detect_cliffs and is_on_floor():
			direction *= -1
			slasher_sprites.flip_h = not slasher_sprites.flip_h
			cliffs_checker.position.x *= -1
		
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


func _on_TopChecker_body_entered(body: ScrubPlayer):
	damage()


func _on_SidesChecker_body_entered(body: ScrubPlayer):
	if not is_staggered:
		body.die(true, global_position)


func _on_StaggerTimer_timeout():
	slasher_sprites.play("walk")
	modulate = Color.white
	is_staggered = false
