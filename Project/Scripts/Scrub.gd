extends KinematicBody2D
class_name ScrubPlayer

## Signals
signal death

## Constants
const MAX_SPEED = 90
const ACCELERATION = MAX_SPEED * 5
const JUMP_FORCE = -152
const GRAVITY = 152
const MAX_FALL_SPEED = MAX_SPEED * 10
const FIREBALL = preload("res://Scenes/fireball.tscn")
const JUMP_PAD_FORCE = -200

## Variables
var velocity := Vector2()
var coins := 0
var gun_on_cooldown := false
var has_fireball := false
var is_jumping := false
var is_attacking := false
var special_uses := 2
var can_die := true

enum DIRECTION {
	LEFT = -1,
	RIGHT = 1,
}

export(DIRECTION) var direction := DIRECTION.RIGHT
var bool_direction: bool = clamp(direction, 0, 1)

# Node references
# Timers
onready var jump_buffer: ScrubJumpBuffer = $JumpBuffer
onready var kick_cooldown := $KickCooldown
onready var gun_cooldown_timer := $GunCooldown

# Sound Players
onready var jump_sound := $Jump
onready var fireball_sound := $Fireball

# Others
onready var scrub_sprites := $AnimatedSprite
onready var mounted_gun := $MountedGun
onready var fireball_origin := $FireballOrigin
onready var kick_collision := $"Kick/CollisionShape2D"


func _ready():
	mounted_gun.position.x = abs(mounted_gun.position.x) * - direction
	mounted_gun.flip_h = not bool_direction
	scrub_sprites.flip_h = not bool_direction
	scrub_sprites.z_index = not bool_direction
	fireball_origin.position.x = abs(fireball_origin.position.x) * - direction
	kick_collision.position.x = abs(kick_collision.position.x) * direction


func _process(_delta):
	mounted_gun.frame = gun_on_cooldown as int
	mounted_gun.offset.y = (scrub_sprites.animation == "idle") as int * scrub_sprites.frame


func _physics_process(delta):
	
	# Store Inputs
	var jump := Input.is_action_just_pressed("jump") # UP, W or spacebar
	var shoot_fireball := Input.is_action_pressed("shoot_fireball") # Q
	var kick := Input.is_action_pressed("kick") # X
	direction = Input.is_action_pressed("right") as int - Input.is_action_pressed("left") as int
	
	velocity.y = min(velocity.y + GRAVITY * delta,
			MAX_FALL_SPEED)
	
	if not is_attacking:
		if kick:
			is_attacking = true
			kick_collision.disabled = false
			kick_cooldown.start()
			direction = 0
		
		elif direction:
			bool_direction = clamp(direction, 0, 1)
			mounted_gun.position.x = abs(mounted_gun.position.x) * - direction
			mounted_gun.flip_h = not bool_direction
			scrub_sprites.flip_h = not bool_direction
			scrub_sprites.z_index = not bool_direction
			fireball_origin.position.x = abs(fireball_origin.position.x) * - direction
			kick_collision.position.x = abs(kick_collision.position.x) * direction
		
		if shoot_fireball and has_fireball and not gun_on_cooldown:
			var fireball = FIREBALL.instance()
			fireball.velocity.x = -5 + 10 * bool_direction as int
			fireball.global_position = fireball_origin.global_position
			get_parent().add_child(fireball)
			gun_cooldown_timer.start()
			gun_on_cooldown = true
			mounted_gun.frame = 1
			fireball_sound.play()
		
		if jump and (is_on_floor() or not jump_buffer.is_stopped()):
			jump_buffer.stop()
			jump_buffer.already_started = true
			velocity.y = JUMP_FORCE
			jump_sound.play()
	
	else: direction = 0
	
	velocity.x = move_toward(velocity.x,
			MAX_SPEED * direction,
			ACCELERATION * delta * (1 + (velocity.x * direction < 0) as int))
	# The above line duplicates the acceleration if the desired direction is
	# oposite to the current direction
	
	if is_on_floor():
		jump_buffer.stop()
		jump_buffer.already_started = false
	elif not jump_buffer.already_started:
		jump_buffer.start()
		jump_buffer.already_started = true
	
	velocity = move_and_slide(velocity, Vector2.UP)
	
	if velocity.y:
		scrub_sprites.play("jump")
	elif velocity.x:
		scrub_sprites.play("walk")
	else:
		scrub_sprites.play("idle")


func _on_Area2D_body_entered(_body):
	emit_signal("death")


func add_coin():
	coins += 1


func bounce():
	velocity.y = JUMP_FORCE * 0.8


func ouch(var enemy_x):
	if can_die:
		set_modulate(Color(1,0.3,0.3,0.3))
		
		velocity = Vector2(1000 - 2000 * int(global_position.x < enemy_x), JUMP_FORCE)
		
		Input.action_release("left")
		Input.action_release("right")
		Input.action_release("jump")
		
		$DeathTimer.start()


func fireball_pickup():
	mounted_gun.show()
	has_fireball = true


func _on_gun_cooldown_timeout():
	gun_on_cooldown = false


func _jump_pad():
	velocity.y = JUMP_PAD_FORCE


func _death():
	set_modulate(Color(1,0.3,0.3,0.3))
	velocity.y = JUMP_FORCE * 1
	Input.action_release("left")
	Input.action_release("right")
	Input.action_release("jump")
	
	$DeathTimer.start()
	can_die = false


func add_special_use():
	special_uses += + 1


func _on_DeathTimer_timeout():
	emit_signal("death")


func _on_kick_cooldown_timeout():
	is_attacking = false
	kick_collision.disabled = true
