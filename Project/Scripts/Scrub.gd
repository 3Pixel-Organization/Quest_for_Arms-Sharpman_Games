extends KinematicBody2D

#Variables
var velocity = Vector2(0,0)
var coins = 0
var direction = 1
var cooldownnotactive = true
var hasfireball = false
var is_jumping = false

onready var Coyote_Timer = $CoyoteTimer
onready var Jump_Buffer = $JumpBuffer	
#Constants
const MAX_SPEED = 450
const ACCELERATION = 200
const JUMPFORCE = -1100
const GRAVITY = 35
const FIREBALL = preload("res://Scenes/Fireball.tscn")
const JUMP_PAD_FORCE = -2000



#Walk Code
func _physics_process(delta):
	var friction = false
	if velocity.y >= 0 && is_jumping:
		is_jumping = false
	print(Engine.get_frames_per_second())   
	if Input.is_action_pressed("right"):
		$AnimatedSprite.flip_h = false
		if sign($Position2D.position.x) == -1:
			$Position2D.position.x *= -1
		velocity.x = min(velocity.x+ACCELERATION, MAX_SPEED)
		$AnimatedSprite.play("walk")
		direction = -1
	elif Input.is_action_pressed("left"):
		$AnimatedSprite.flip_h = true
		if sign($Position2D.position.x) == 1:
			$Position2D.position.x *= -1
		velocity.x = max(velocity.x-ACCELERATION, -MAX_SPEED)
		$AnimatedSprite.play("walk")
		direction = 1
	else:
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

	velocity.y = velocity.y + GRAVITY
	
	if Input.is_action_just_pressed("jump"):
		if is_on_floor() || !Coyote_Timer.is_stopped():
			Coyote_Timer.stop()
			is_jumping = true
			velocity.y = JUMPFORCE
		else:
			Jump_Buffer.start()
	
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

	if Input.is_action_pressed("Shoot Fireball") and cooldownnotactive:
		if hasfireball == true:
			var fireball = FIREBALL.instance()
			if sign($Position2D.position.x) == 1:
				fireball._set_fireball_direction(1)
			else:
				fireball._set_fireball_direction(-1)
			get_parent().add_child(fireball)
			print("ok")
			fireball.global_position = $Position2D.global_position
			$Timer2.start()
			cooldownnotactive = false

#Dying Code
func _on_Area2D_body_entered(body):
		get_tree().change_scene("res://Scenes/death.tscn")

#Collect Coin Code
func add_coin():
	coins= coins + 1




func bounce():
	velocity.y = JUMPFORCE * 0.8
	
func ouch(var enemyposx):
	set_modulate(Color(1,0.3,0.3,0.3))
	velocity.y = JUMPFORCE * 1
	if position.x < enemyposx:
		velocity.x = -1000
	elif position.x > enemyposx:
		velocity.x = 1000
	
	Input.action_release("left")
	Input.action_release("right")
	
	$Timer.start()



func _on_Timer_timeout():
	get_tree().change_scene("res://Scenes/death.tscn")

func _on_Timer2_timeout():
	cooldownnotactive = true

func fireball_pickup():
	hasfireball = true

func _jump_pad():
	velocity.y = JUMP_PAD_FORCE



func _death():
	set_modulate(Color(1,0.3,0.3,0.3))
	velocity.y = JUMPFORCE * 1
	Input.action_release("left")
	Input.action_release("right")
	
	$Timer.start()
