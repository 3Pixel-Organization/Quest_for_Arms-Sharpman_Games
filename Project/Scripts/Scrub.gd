extends KinematicBody2D

## Variables
var velocity = Vector2()
var coins = 0
var gun_on_cooldown = false
var has_fireball = false
var is_jumping = false
var is_attacking = false
var special_uses = 2
var can_die = true
var direction

## Node references
onready var CoyoteTimer = $CoyoteTimer
onready var JumpBuffer = $JumpBuffer
onready var animated_sprite = $AnimatedSprite
onready var jump_buffer = $JumpBuffer

## Constants
const MAX_SPEED = 90
const ACCELERATION = 40
const JUMP_FORCE = -220 # -150
const GRAVITY = 7 # 152
#const MAX_FALL_SPEED = MAX_SPEED * 10
const FIREBALL = preload("res://Scenes/fireball.tscn")
const JUMP_PAD_FORCE = -200

## Signals
signal death

func _process(_delta):
	$MountedGun.frame = int(gun_on_cooldown)
	$MountedGun.offset.y = ($AnimatedSprite.animation == "idle") as int * $AnimatedSprite.frame

## run forrest run
func _physics_process(delta):
	
	## Store Inputs
	var right = Input.is_action_pressed("right")
	var left = Input.is_action_pressed("left")
#	direction = Input.is_action_pressed("right") as int - Input.is_action_pressed("left") as int
#	var clamp_direction : bool = clamp(direction, 0, 1)
	
	var jump = Input.is_action_just_pressed("jump")
	var shoot_fireball = Input.is_action_pressed("shoot_fireball")
	var kick = Input.is_action_pressed("kick")
	
	## Incomplete new movement code
#	if direction:
#		$MountedGun.position.x = abs($MountedGun.position.x) * -direction
#		$MountedGun.flip_h = !clamp_direction
#		$AnimatedSprite.flip_h = !clamp_direction
#		$AnimatedSprite.z_index = !clamp_direction
#		$FireballOrigin.position.x = abs($FireballOrigin.position.x) * -direction
#		$"Kick/CollisionShape2D".position.x = abs($"Kick/CollisionShape2D".position.x) * direction
#		velocity.x = lerp(velocity.x, MAX_SPEED * direction, 20 * delta)
#	else:
#		velocity.x = lerp(velocity.x, 0, 20 * delta)
#
#	velocity.x = clamp(velocity.x, -MAX_SPEED, MAX_SPEED)
#	velocity.y = min(velocity.y + (GRAVITY * delta), MAX_FALL_SPEED)
#	if !is_on_floor() && jump_buffer.is_stopped():
#		jump_buffer.start()
#	if jump && is_on_floor():
#		velocity.y = JUMP_FORCE
#	velocity = move_and_slide(velocity, Vector2.UP)
#	print(velocity)
#
#	if velocity.y:
#		animated_sprite.play("jump")
#	elif velocity.x:
#		animated_sprite.play("walk")
#	else:
#		animated_sprite.play("idle")
	
	is_jumping = (velocity.y <= 0)
	var friction = false
	if !is_attacking:
		if right:
			$AnimatedSprite.flip_h = false
			$AnimatedSprite.z_index = 0
			$MountedGun.flip_h = false
			$MountedGun.position.x = -abs($MountedGun.position.x)
			
			$FireballOrigin.position.x = -abs($FireballOrigin.position.x)
			
			$"Kick/CollisionShape2D".position.x = abs($"Kick/CollisionShape2D".position.x)
			
			velocity.x = min(velocity.x+ACCELERATION, MAX_SPEED)
			
			if animated_sprite.animation != "walk":
				animated_sprite.play("walk")
			
			direction = 1
		
		elif left:
			$AnimatedSprite.flip_h = true
			$AnimatedSprite.z_index = 1
			$MountedGun.flip_h = true
			$MountedGun.position.x = abs($MountedGun.position.x)
			
			$FireballOrigin.position.x = abs($FireballOrigin.position.x)
			
			$"Kick/CollisionShape2D".position.x = -abs($"Kick/CollisionShape2D".position.x)
			
			velocity.x = max(velocity.x-ACCELERATION, -MAX_SPEED)
			
			if animated_sprite.animation != "walk":
				animated_sprite.play("walk")
			
			direction = -1
		
		else:
			animated_sprite.play("idle")
			friction = true
			velocity.x = lerp(velocity.x, 0, 0.2)
	else:
		friction = true
		velocity.x = lerp(velocity.x, 0, 0.2)
	
	if kick:
		is_attacking = true
		$"Kick/CollisionShape2D".disabled = false
		$KickCooldown.start()
	
	if jump && !is_attacking:
		if is_on_floor() || !CoyoteTimer.is_stopped():
			$Jump.play()
			CoyoteTimer.stop()
			is_jumping = true
			velocity.y = JUMP_FORCE
		else:
			JumpBuffer.start()
	
	if is_on_floor():
		if friction:
			velocity.x = lerp(velocity.x, 0, 0.2)
	else:
		animated_sprite.play("jump")
	
	velocity.y += GRAVITY
	
	var was_on_floor = is_on_floor()
	velocity = move_and_slide(velocity,Vector2.UP)
	if !is_on_floor() && was_on_floor && !is_jumping:
		CoyoteTimer.start()
	if is_on_floor() && !JumpBuffer.is_stopped():
		JumpBuffer.stop()
		CoyoteTimer.stop()
		is_jumping = true
		velocity.y = JUMP_FORCE
	velocity.x = lerp(velocity.x,0,0.4)
	
	if shoot_fireball && !gun_on_cooldown && has_fireball:
		$Fireball.play()
		$MountedGun.frame = 1
		var fireball = FIREBALL.instance()
		fireball.velocity.x = -5 + 10 * direction as int
		get_parent().add_child(fireball)
		fireball.global_position = $FireballOrigin.global_position
		$GunCooldown.start()
		gun_on_cooldown = true

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

func _on_gun_cooldown_timeout():
	gun_on_cooldown = false

func fireball_pickup():
	$MountedGun.show()
	has_fireball = true

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
	$"kick/CollisionShape2D".disabled = true
