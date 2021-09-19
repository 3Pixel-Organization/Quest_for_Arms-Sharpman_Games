extends KinematicBody2D
class_name ScrubPlayer

## Signals
signal death

## Constants
const MAX_SPEED = 110
const ACCELERATION = MAX_SPEED * 7
const JUMP_SPEED = -180
const GRAVITY = 280
const MAX_FALL_SPEED = MAX_SPEED * 10
const FIREBALL = preload("res://Scenes/fireball.tscn")
const JUMPPAD_SPEED = -200

## Variables
var velocity := Vector2()
var coins := 0 setget set_coins
var has_fireball := false
var can_die := true

enum DIRECTION {
	LEFT = -1,
	RIGHT = 1,
}

export(DIRECTION) var direction := DIRECTION.RIGHT

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
onready var hud_coins := $"HUD/GameHUD/PanelContainer/HSplitContainer/Coins"


func _ready():
	parse_direction(direction)


func _process(_delta):
	mounted_gun.frame = not gun_cooldown_timer.is_stopped() as int
	mounted_gun.offset.y = (scrub_sprites.animation == "idle") as int * scrub_sprites.frame


func _physics_process(delta):
	
	# Store Inputs
	var jump := Input.is_action_just_pressed("jump") # UP, W or spacebar
	var shoot_fireball := Input.is_action_pressed("shoot_fireball") # Q
	var kick := Input.is_action_pressed("kick") # X
	direction = Input.is_action_pressed("right") as int - Input.is_action_pressed("left") as int
	
	velocity.y = min(velocity.y + GRAVITY * delta,
			MAX_FALL_SPEED)
	
	if is_on_floor():
		jump_buffer.stop()
		jump_buffer.already_started = false
	elif not jump_buffer.already_started:
		jump_buffer.start()
		jump_buffer.already_started = true
	
	if kick_cooldown.is_stopped():
		if kick:
			kick_collision.disabled = false
			kick_cooldown.start()
			direction = 0
		
		elif direction:
			parse_direction(direction)
		
		if shoot_fireball and has_fireball and gun_cooldown_timer.is_stopped():
			var fireball = FIREBALL.instance()
			fireball.velocity.x = -5 + 10 * clamp(direction, 0, 1)
			fireball.global_position = fireball_origin.global_position
			get_parent().add_child(fireball)
			gun_cooldown_timer.start()
			mounted_gun.frame = 1
			fireball_sound.play()
		
		if jump and (is_on_floor() or not
				(jump_buffer.is_stopped() and jump_buffer.already_started)):
			jump_buffer.stop()
			jump_buffer.already_started = true
			velocity.y = JUMP_SPEED
			jump_sound.play()
	
	else: direction = 0
	
	velocity.x = move_toward(velocity.x,
			MAX_SPEED * direction,
			ACCELERATION * delta * (1 + (velocity.x * direction < 0) as int))
	# The above line duplicates the acceleration if the desired direction is
	# oposite to the current direction
	
	velocity = move_and_slide(velocity, Vector2.UP)
	
	if velocity.y:
		scrub_sprites.play("jump")
	elif velocity.x:
		scrub_sprites.play("walk")
	else:
		scrub_sprites.play("idle")


func parse_direction(direction: int):
	var bool_direction: bool = clamp(direction, 0, 1)
	mounted_gun.flip_h = not bool_direction
	scrub_sprites.flip_h = not bool_direction
	scrub_sprites.z_index = not bool_direction
	mounted_gun.position.x = abs(mounted_gun.position.x) * - direction
	fireball_origin.position.x = abs(fireball_origin.position.x) * - direction
	kick_collision.position.x = abs(kick_collision.position.x) * direction


func _on_Fallzone_body_entered(_body):
	emit_signal("death")


func bounce():
	velocity.y = JUMP_SPEED * 0.8


func ouch(enemy_x: float):
	death(true, Vector2(enemy_x, 0))


func fireball_pickup():
	has_fireball = true
	mounted_gun.show()


func _jump_pad():
	velocity.y = JUMPPAD_SPEED


func death(bounce: bool = false, enemy_pos: Vector2 = Vector2()) -> void:
	if not can_die:
		return
	set_modulate(Color(1,0.3,0.3,0.3))
	velocity.y = JUMP_SPEED * 1
	if bounce:
		velocity.x = 200 - 400 * (global_position.x < enemy_pos.x) as int
	Input.action_release("left")
	Input.action_release("right")
	Input.action_release("jump")
	
	$DeathTimer.start()


func _on_DeathTimer_timeout():
	emit_signal("death")


func set_coins(value):
	coins = value
	hud_coins.text = "0" + coins as String if coins < 10 else coins as String
