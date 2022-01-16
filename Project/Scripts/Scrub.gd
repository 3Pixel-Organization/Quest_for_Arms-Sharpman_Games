class_name ScrubPlayer
extends KinematicBody2D

# Signals
signal death(wait_time)

enum DIRECTION {
	LEFT = -1,
	RIGHT = 1,
}

# Constants
const MAX_SPEED = 77
const ACCELERATION = MAX_SPEED * 7
const JUMP_SPEED = -180
const GRAVITY = 325
const MAX_FALL_SPEED = MAX_SPEED * 10
const FIREBALL = preload("res://Scenes/Fireball.tscn")

export(DIRECTION) var direction := DIRECTION.RIGHT
export var can_die: bool = true

# Member variables
var velocity: Vector2 = Vector2.ZERO
var coins: int setget set_coins
var has_fireball: bool = GlobalVariables.player["Gun"]
var bool_direction: bool

# Node references
onready var jump_buffer: Timer = $"JumpBuffer"
onready var kick_cooldown: Timer = $"KickCooldown"
onready var gun_cooldown_timer: Timer = $"GunCooldown"
onready var jump_sound: AudioStreamPlayer = $"Jump"
onready var fireball_sound: AudioStreamPlayer = $"Fireball"
onready var animator: AnimationPlayer = $"AnimationPlayer"
onready var scrub_sprite: Sprite = $"Sprite"
onready var mounted_gun: Sprite = $"MountedGun"
onready var fireball_origin: Position2D = $"FireballOrigin"
onready var melee_area: Area2D = $"Kick"
onready var hud_coins: Label = $"HUD/GameHUD/PanelContainer/HSplitContainer/Coins"

# Camera and Tween are optional; They're only used for the death zoom
onready var camera := get_node_or_null("Camera2D")
onready var tween: Tween = get_node_or_null("Tween")


func _ready() -> void:
	self.coins = GlobalVariables.player["Coins"]
	mounted_gun.visible = has_fireball
	parse_direction(direction)


func _physics_process(delta: float) -> void:
	
	# Store Inputs
	var jump: bool = Input.is_action_just_pressed("jump") 						# UP, W or spacebar
	var shoot_fireball: bool = Input.is_action_just_pressed("shoot_fireball")	# Q
	var kick: bool = Input.is_action_just_pressed("kick") 						# X
	direction = (Input.is_action_pressed("right") as int -						# A
			Input.is_action_pressed("left") as int) 							# D
	
	velocity.y = min(velocity.y + GRAVITY * delta,
			MAX_FALL_SPEED)
	
	var is_on_floor: bool = is_on_floor()
	
	if is_on_floor:
		jump_buffer.stop()
		jump_buffer.already_started = false
	elif not jump_buffer.already_started:
		jump_buffer.start()
		jump_buffer.already_started = true
	
	if kick_cooldown.is_stopped():
		if kick and is_on_floor:
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
		
		if jump and (is_on_floor or not
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


func parse_direction(parsed_direction: int) -> void:
	bool_direction = clamp(parsed_direction, 0, 1)
	mounted_gun.flip_h = not bool_direction
	mounted_gun.z_index = bool_direction as int - 1
	scrub_sprite.flip_h = not bool_direction
	fireball_origin.position.x = abs(fireball_origin.position.x) * - parsed_direction
	melee_area.position.x = abs(melee_area.position.x) * parsed_direction


func fireball_pickup() -> void:
	has_fireball = true
	mounted_gun.show()


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
func _on_KickCooldown_timeout() -> void:
	melee_area.monitoring = false


func _on_Kick_body_entered(body: PhysicsBody2D) -> void:
	if body.has_method("damage"):
		body.damage()
	elif body.has_method("desintegrate"):
		body.desintegrate()


func _on_GunCooldown_timeout() -> void:
	mounted_gun.frame = 0

# Setters and getters
func set_coins(value: int) -> void:
	coins = value
	hud_coins.text = (coins as String).pad_zeros(2)
