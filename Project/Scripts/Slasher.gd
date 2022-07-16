extends KinematicBody2D


enum Direction {
	LEFT = -1,
	RIGHT = 1,
}

const GRAVITY = 20

export(Direction) var direction: int = -1
export var detect_cliffs: bool = true
export var speed: int = 20
export var health: int = 2

var velocity: Vector2 = Vector2.ZERO
var is_staggered: bool = false

onready var slasher_sprites: AnimatedSprite = $"AnimatedSprite"
onready var hitbox: Area2D = $"Hitbox"
onready var cliffs_checker: RayCast2D = $"FloorChecker"
onready var stagger_timer: Timer = $"StaggerTimer"
onready var death_timer: Timer = $"DeathTimer"

func _ready() -> void:
	scale.x = direction * -1
	cliffs_checker.enabled = detect_cliffs


func _physics_process(delta: float) -> void:
	if (is_on_wall() or
			not cliffs_checker.is_colliding() and detect_cliffs and is_on_floor()):
		direction *= -1
		scale.x *= -1
	
	velocity.y += GRAVITY
	
	if not is_staggered:
		velocity.x = speed * direction
	else:
		velocity.x = move_toward(velocity.x, 0, 100 * delta) # the last parameter is an arbitrary number
	
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
		stagger_timer.start()


func die() -> void:
	set_physics_process(false)
#	top_checker.set_deferred("monitoring", false)
#	sides_checker.set_deferred("monitoring", false)
	hitbox.set_deferred("monitoring", false)
	set_deferred("collision_layer", 0)
	slasher_sprites.play("squashed")
	($"DeathTimer" as Timer).start()


#func _on_TopChecker_body_entered(body: ScrubPlayer) -> void:
#	if not body: return
#
#	damage()
#	body.velocity.y = -160
#
#
#func _on_SidesChecker_body_entered(body: ScrubPlayer) -> void:
#	if not is_staggered:
#		body.die()
#	else:
#		body.velocity.x = (325/1.5 - 650/1.5 *
#				(body.global_position.x < global_position.x) as int)


func _on_StaggerTimer_timeout() -> void:
	slasher_sprites.play("walk")
	modulate = Color.white
	is_staggered = false


func _on_DeathTimer_timeout() -> void:
	queue_free()


func _on_Hitbox_body_entered(body: ScrubPlayer) -> void:
	if not body: return
	
	if body.velocity.y > 0:
		damage()
		body.velocity.y = -160
	elif is_staggered:
		body.velocity.x = 215 * sign(global_position.x - body.global_position.x)
	else:
		body.die()
