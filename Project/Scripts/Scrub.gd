extends KinematicBody2D

## Vars
var velocity = Vector2()
var coins = 0
var direction = 1
var cooldownnotactive = true
var hasfireball = false
var is_jumping = false
var is_attacking = false
var special_uses = 2
var knockback = false
var fire1 = preload("res://Assets/Sprites/Items/mountedGun-export.png")
var fire2 = preload("res://Assets/Sprites/Items/mountedGun-export-export.png")

onready var Coyote_Timer = $CoyoteTimer
onready var Jump_Buffer = $JumpBuffer

## Constants
const MAX_SPEED = 450
const ACCELERATION = 200
const JUMPFORCE = -1100
const GRAVITY = 35
const FIREBALL = preload("res://Scenes/Fireball.tscn")
const JUMP_PAD_FORCE = -2000

## Signals
signal death

func _ready():
	$"Sprite-0003-export".hide()

func _process(_delta):
	if cooldownnotactive == true:
		$"Sprite-0003-export".set_texture(fire1)
	else:
		$"Sprite-0003-export".set_texture(fire2)

## run forrest run
func _physics_process(_delta):
	if knockback == false:
		var friction = false
		
		is_jumping = (velocity.y <= 0)
		
		if Input.is_action_pressed("right") && is_attacking == false:
			$AnimatedSprite.flip_h = false
			$"Sprite-0003-export".flip_h = false
			$AnimatedSprite.z_index = 0
			
			$Position2D.position.x = abs($Position2D.position.x)
			
			$"attaclk 1/CollisionShape2D".position.x = abs($"attaclk 1/CollisionShape2D".position.x)
			
			velocity.x = min(velocity.x+ACCELERATION, MAX_SPEED)
			
			$AnimatedSprite.play("walk")
			direction = -1
			
		elif Input.is_action_pressed("left") && is_attacking == false:
			$AnimatedSprite.flip_h = true
			$"Sprite-0003-export".flip_h = true
			$AnimatedSprite.z_index = 1
			
			$Position2D.position.x = -abs($Position2D.position.x)
			
			$"attaclk 1/CollisionShape2D".position.x = -abs($"attaclk 1/CollisionShape2D".position.x)
			
			velocity.x = max(velocity.x-ACCELERATION, -MAX_SPEED)
			
			$AnimatedSprite.play("walk")
			direction = 1
			
		else:
			if is_attacking == false:
				$AnimatedSprite.play("Idle")
			
			friction = true
			velocity.x = lerp (velocity.x, 0, 0.2)
			
		if is_on_floor():
			if friction == true:
				velocity.x = lerp (velocity.x, 0, 0.2)
			else:
				if friction == true:
					velocity.x = lerp (velocity.x, 0, 0.05)
		if not is_on_floor():
			$AnimatedSprite.play("jump")

		velocity.y += GRAVITY
		
		if Input.is_action_just_pressed("jump") && is_attacking == false:
			if is_on_floor() || !Coyote_Timer.is_stopped():
				$AudioStreamPlayer2.play()
				Coyote_Timer.stop()
				is_jumping = true
				velocity.y = JUMPFORCE
			else:
				Jump_Buffer.start()
		
		if Input.is_action_just_pressed("Attack 1"):
			is_attacking = true
			$"attaclk 1/CollisionShape2D".disabled = false
			$Timer3.start()
		
		var was_on_floor = is_on_floor()
		velocity = move_and_slide(velocity,Vector2.UP)
		if !is_on_floor() && was_on_floor && !is_jumping:
			Coyote_Timer.start()
		if is_on_floor() && !Jump_Buffer.is_stopped():
			Jump_Buffer.stop()
			Coyote_Timer.stop()
			is_jumping = true
			velocity.y = JUMPFORCE
		velocity.x = lerp(velocity.x,0,0.4)

		if Input.is_action_pressed("Shoot Fireball") && cooldownnotactive:
			if hasfireball == true:
				$AudioStreamPlayer.play()
				var fireball = FIREBALL.instance()
				if sign($Position2D.position.x) == 1:
					fireball._set_fireball_direction(1)
				else:
					fireball._set_fireball_direction(-1)
				get_parent().add_child(fireball)
				fireball.global_position = $Position2D.global_position
				$Timer2.start()
				cooldownnotactive = false

func _on_Area2D_body_entered(_body):
	emit_signal("death")

func add_coin():
	coins= coins + 1

func bounce():
	velocity.y = JUMPFORCE * 0.8
	
func ouch(var enemyposx):
	set_modulate(Color(1,0.3,0.3,0.3))
	
	velocity = Vector2(1000 * int(position.x > enemyposx), JUMPFORCE)
	
	Input.action_release("left")
	Input.action_release("right")
	Input.action_release("jump")
	
	$Timer.start()

func _on_Timer_timeout():
	emit_signal("death")

func _on_Timer2_timeout():
	cooldownnotactive = true

func fireball_pickup():
	$"Sprite-0003-export".show()
	hasfireball = true

func _jump_pad():
	velocity.y = JUMP_PAD_FORCE

func _death():
	set_modulate(Color(1,0.3,0.3,0.3))
	velocity.y = JUMPFORCE * 1
	Input.action_release("left")
	Input.action_release("right")
	Input.action_release("jump")
	
	$Timer.start()

func play_sound():
	$AudioStreamPlayer3.play()

func add_special_use():
	special_uses = special_uses + 1

func _on_Timer3_timeout():
	is_attacking = false
	$"attaclk 1/CollisionShape2D".disabled = true

func _on_Timer4_timeout():
	is_attacking = false
	$"attack 2/CollisionShape2D".disabled = true

func _knockback():
	knockback = true
	get_tree().get_root().set_disable_input(true)
	if direction == -1:
		velocity.x = -1500
	else: 
		velocity.x = 1500
	$Timer5.start()

func _on_Timer5_timeout():
	knockback = false
	get_tree().get_root().set_disable_input(false)
