extends KinematicBody2D

var speed = 95
var health = 50
var velocity = Vector2()
var is_dead = false
export var direction = -1
export var detect_cliffs = true
var is_staggered = false

func _ready():
	$AnimatedSprite.flip_h = direction > 0 ## If the direction is 1, so will be flip_h
	$floor_checker.position.x = $CollisionShape2D.shape.get_extents().x * direction
	$floor_checker.enabled = detect_cliffs

func _physics_process(_delta):
		if !is_dead && is_on_wall() || !$floor_checker.is_colliding() && detect_cliffs && is_on_floor():
			direction *= -1
			$AnimatedSprite.flip_h = !$AnimatedSprite.flip_h
			$floor_checker.position.x = $CollisionShape2D.shape.get_extents().x * direction
		
		velocity = Vector2(speed * direction, velocity.y + 20)
		velocity = move_and_slide(velocity,Vector2.UP)

func _on_top_checker_body_entered(body):
	if !is_staggered:
		if health <= 30:
			is_dead = true
			queue_free()
			$Timer.start()
			speed = 0
			set_collision_layer_bit(4, false)
			set_collision_mask_bit(0, false)
			$top_checker.set_collision_layer_bit(4, false)
			$top_checker.set_collision_mask_bit(0, false)
			$sides_checker.set_collision_layer_bit(4, false)
			$sides_checker.set_collision_mask_bit(0, false)
		else:
			is_staggered = true
			health -= 30
			speed = 0
			set_modulate(Color(0.3,0.3,0.3,0.6))
			$AnimatedSprite.play("stagger")
			$Timer2.start()
		if body.name == "Scrub":
			body.bounce()
	

func _on_sides_checker_body_entered(body):
	if body.name == "Scrub":
		if !is_staggered:
			body.ouch(position.x)

func _on_Timer_timeout():
	queue_free()

func fireball_dead():
	if health <= 30:
		is_dead = true
		queue_free()
		speed = 0
		set_collision_layer_bit(4, false)
		set_collision_mask_bit(0, false)
		$top_checker.set_collision_layer_bit(4, false)
		$top_checker.set_collision_mask_bit(0, false)
		$sides_checker.set_collision_layer_bit(4, false)
		$sides_checker.set_collision_mask_bit(0, false)
		$Timer.start()
	else:
		if !is_staggered:
			is_staggered = true
			health = health - 30
			speed = 0
			$AnimatedSprite.play("stagger")
			set_modulate(Color(0.3,0.3,0.3,0.6))
			$Timer2.start()

func _on_Timer2_timeout():
	$AnimatedSprite.play("walk")
	set_modulate(Color(1,1,1,1))
	speed = 95
	is_staggered = false

func kick():
	if !is_staggered:
		if health <= 20:
			is_dead = true
			queue_free()
			$Timer.start()
			speed = 0
			set_collision_layer_bit(4, false)
			set_collision_mask_bit(0, false)
			$top_checker.set_collision_layer_bit(4, false)
			$top_checker.set_collision_mask_bit(0, false)
			$sides_checker.set_collision_layer_bit(4, false)
			$sides_checker.set_collision_mask_bit(0, false)
		else:
			is_staggered = true
			health -= 20
			speed = 0
			set_modulate(Color(0.3,0.3,0.3,0.6))
			$AnimatedSprite.play("stagger")
			$Timer2.start()

func _on_sides_checker_area_entered(area):
	if area.is_in_group("kick"):
		kick()
