class_name ScrubPlayer
extends KinematicBody2D

## Signals
signal death(wait_time)

## Constants
const MAX_SPEED = 77
const ACCELERATION = MAX_SPEED * 7
const JUMP_SPEED = -180
const GRAVITY = 325
const MAX_FALL_SPEED = MAX_SPEED * 10
const FIREBALL = preload("res://Scenes/Fireball.tscn")
const JUMPPAD_SPEED = -200

## Variables
var velocity := Vector2()
var coins: int setget set_coins
var has_fireball: bool = GlobalVariables.player["Gun"]

enum DIRECTION {
	LEFT = -1,
	RIGHT = 1,
}

export(DIRECTION) var direction := DIRECTION.RIGHT
var bool_direction: bool

export var can_die: bool = true

# Node references
# Timers
onready var jump_buffer := $"JumpBuffer"
onready var kick_cooldown := $"KickCooldown"
onready var gun_cooldown_timer := $"GunCooldown"

# Sound Players
onready var jump_sound := $"Jump"
onready var fireball_sound := $"Fireball"

# Others
onready var animator := $"AnimationPlayer"
onready var scrub_sprite := $"Sprite"
onready var mounted_gun := $"MountedGun"
onready var fireball_origin := $"FireballOrigin"
onready var melee_area := $"Kick"
onready var hud_coins := $"HUD/GameHUD/PanelContainer/HSplitContainer/Coins"
onready var camera := get_node_or_null("Camera2D")
onready var tween := get_node_or_null("Tween")


func _ready():
	self.coins = GlobalVariables.player["Coins"]
	mounted_gun.visible = has_fireball
	parse_direction(direction)


func _physics_process(delta):
	
	# Store Inputs
	var jump := Input.is_action_just_pressed("jump") 			# UP, W or spacebar
	var shoot_fireball := Input.is_action_just_pressed("shoot_fireball") # Q
	var kick := Input.is_action_just_pressed("kick") 					# X
	direction = (Input.is_action_pressed("right") as int -			# A
			Input.is_action_pressed("left") as int) 				# D
	
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
			melee_area.monitoring = true
			kick_cooldown.start()
			direction = 0
		
		elif direction:
			parse_direction(direction)
		
		if shoot_fireball and has_fireball and gun_cooldown_timer.is_stopped():
			var fireball = FIREBALL.instance()
			fireball.velocity.x = -200 + 400 * bool_direction as int
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
		animator.play("Jump")
	elif velocity.x:
		animator.play("Walk")
	else:
		animator.play("Idle")


func parse_direction(parsed_direction: int):
	bool_direction = clamp(parsed_direction, 0, 1)
	mounted_gun.flip_h = not bool_direction
	mounted_gun.z_index = bool_direction as int - 1
	scrub_sprite.flip_h = not bool_direction
	fireball_origin.position.x = abs(fireball_origin.position.x) * - parsed_direction
	melee_area.position.x = abs(melee_area.position.x) * parsed_direction


func fireball_pickup():
	has_fireball = true
	mounted_gun.show()


func _jump_pad():
	velocity.y = JUMPPAD_SPEED


func die() -> void:
	if not can_die:
		return
	
	modulate = Color(1,0.3,0.3,0.3) # great color :+1:
	Input.action_release("left")
	Input.action_release("right")
	Input.action_release("jump")
	
	set_physics_process(false)
	pause_mode = PAUSE_MODE_PROCESS
	emit_signal("death", 1.3)
	animator.play("Death")
	
	if camera:
		if tween:
			var tweened: bool = tween.interpolate_property(camera, "zoom", null,
					Vector2(0.5, 0.5), 1.2, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
			assert(tweened == true, "could not define tween lol")
			tweened = tween.start()
			assert(tweened == true, "could not start tween lol")
		else:
			camera.zoom = Vector2(0.5,0.5)



# Melee attack logic
func _on_KickCooldown_timeout():
	melee_area.monitoring = false


func _on_Kick_body_entered(body) -> void:
	if body.has_method("damage"):
		body.damage()
	elif body.has_method("desintegrate"):
		body.desintegrate()


func _on_GunCooldown_timeout():
	mounted_gun.frame = 0

# Setters and getters
func set_coins(value):
	coins = value
	hud_coins.text = (coins as String).pad_zeros(2)
