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

## Direction setup
enum {
	LEFT,
	RIGHT,
}

export var direction = RIGHT

## Node references
onready var CoyoteTimer = $CoyoteTimer
onready var JumpBuffer = $JumpBuffer

## Constants
const MAX_SPEED = 90
const ACCELERATION = 40
const JUMPFORCE = -220
const GRAVITY = 7
const FIREBALL = preload("res://Scenes/fireball.tscn")
const JUMP_PAD_FORCE = -200

## Signals
signal death

func _process(_delta):
	$MountedGun.frame = int(gun_on_cooldown)
	$MountedGun.offset.y = ($AnimatedSprite.animation == "idle") as int * $AnimatedSprite.frame

## run forrest run
func _physics_process(_delta):
	var friction = false
	
	## Store Inputs
	var right = Input.is_action_pressed("right")
	var left = Input.is_action_pressed("left")
	var jump = Input.is_action_just_pressed("jump")
	var shoot_fireball = Input.is_action_pressed("shoot_fireball")
	var kick = Input.is_action_pressed("kick")
	
	is_jumping = (velocity.y <= 0)
	
	if !is_attacking:
		if right:
			$AnimatedSprite.flip_h = false
			$AnimatedSprite.z_index = 0
			$MountedGun.flip_h = false
			$MountedGun.position.x = -abs($MountedGun.position.x)
			
			$FireballOrigin.position.x = -abs($FireballOrigin.position.x)
			
			$"Kick/CollisionShape2D".position.x = abs($"Kick/CollisionShape2D".position.x)
			
			velocity.x = min(velocity.x+ACCELERATION, MAX_SPEED)
			
			if $AnimatedSprite.animation != "walk":
				$AnimatedSprite.play("walk")
			
			direction = RIGHT
		
		elif left:
			$AnimatedSprite.flip_h = true
			$AnimatedSprite.z_index = 1
			$MountedGun.flip_h = true
			$MountedGun.position.x = abs($MountedGun.position.x)
			
			$FireballOrigin.position.x = abs($FireballOrigin.position.x)
			
			$"Kick/CollisionShape2D".position.x = -abs($"Kick/CollisionShape2D".position.x)
			
			velocity.x = max(velocity.x-ACCELERATION, -MAX_SPEED)
			
			if $AnimatedSprite.animation != "walk":
				$AnimatedSprite.play("walk")
			
			direction = LEFT
		
		else:
			$AnimatedSprite.play("idle")
			friction = true
			velocity.x = lerp (velocity.x, 0, 0.2)
	else:
		friction = true
		velocity.x = lerp (velocity.x, 0, 0.2)
	
	if kick:
		is_attacking = true
		$"Kick/CollisionShape2D".disabled = false
		$KickCooldown.start()
	
	if jump && !is_attacking:
		if is_on_floor() || !CoyoteTimer.is_stopped():
			$Jump.play()
			CoyoteTimer.stop()
			is_jumping = true
			velocity.y = JUMPFORCE
		else:
			JumpBuffer.start()
	
	if is_on_floor():
		if friction == true:
			velocity.x = lerp(velocity.x, 0, 0.2)
		else:
			if friction == true: ## what?? why is the condition repeated here?
				velocity.x = lerp(velocity.x, 0, 0.05)
	
	else:
		$AnimatedSprite.play("jump")
	
	velocity.y += GRAVITY
	
	var was_on_floor = is_on_floor()
	velocity = move_and_slide(velocity,Vector2.UP)
	if !is_on_floor() && was_on_floor && !is_jumping:
		CoyoteTimer.start()
	if is_on_floor() && !JumpBuffer.is_stopped():
		JumpBuffer.stop()
		CoyoteTimer.stop()
		is_jumping = true
		velocity.y = JUMPFORCE
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
	velocity.y = JUMPFORCE * 0.8
	
func ouch(var enemy_x):
	if can_die:
		set_modulate(Color(1,0.3,0.3,0.3))
		
		velocity = Vector2(1000 - 2000 * int(global_position.x < enemy_x), JUMPFORCE)
		
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
	velocity.y = JUMPFORCE * 1
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
