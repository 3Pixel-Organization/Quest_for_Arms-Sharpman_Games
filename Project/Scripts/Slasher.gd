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


func _ready() -> void:
	scale.x = direction * -1
	cliffs_checker.enabled = detect_cliffs


func _physics_process(_delta: float) -> void:
		if is_on_wall() or not cliffs_checker.is_colliding() and detect_cliffs and is_on_floor():
			direction *= -1
			scale.x *= -1
		
		velocity.y += GRAVITY
		
		if not is_staggered:
			velocity.x = speed * direction
		else:
			velocity.x = move_toward(velocity.x, 0, 5) # the last parameter is an arbitrary number
		
		velocity = move_and_slide(velocity, Vector2.UP)


func damage(damage: int = 1, knockback_vec: Vector2 = velocity) -> void:
	if is_staggered: return
	
	health -= damage
	is_staggered = true
	
	if health <= 0:
		die()
	else:
		set_deferred("velocity", knockback_vec)
		slasher_sprites.play("stagger")
		($"StaggerTimer" as Timer).start()


func die() -> void:
	set_physics_process(false)
	top_checker.set_deferred("monitoring", false)
	sides_checker.set_deferred("monitoring", false)
	($"CollisionShape2D" as CollisionShape2D).set_deferred("disable", true)
	slasher_sprites.play("squashed")
	($"DeathTimer" as Timer).start()


func _on_TopChecker_body_entered(body: ScrubPlayer) -> void:
	if not body: return
	
	damage()
	body.velocity.y = -160


func _on_SidesChecker_body_entered(body: ScrubPlayer) -> void:
	if not is_staggered:
		body.die()
	else:
		body.velocity.x = (325/1.5 - 650/1.5 *
				(body.global_position.x < global_position.x) as int)


func _on_StaggerTimer_timeout() -> void:
	slasher_sprites.play("walk")
	modulate = Color.white
	is_staggered = false


func _on_DeathTimer_timeout() -> void:
	queue_free()
