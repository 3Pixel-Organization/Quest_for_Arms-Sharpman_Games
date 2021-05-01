extends KinematicBody2D

export var speed = 100
var velocity = Vector2()
var is_dead = false
export var direction = -1
export var detect_cliffs = true

func _ready():
	if direction == 1:
		$AnimatedSprite.flip_h = true
	$floor_checker.position.x = $CollisionShape2D.shape.get_extents().x * direction
	$floor_checker.enabled = detect_cliffs

func _physics_process(delta):
	if is_dead == false:
		if is_on_wall() or not $floor_checker.is_colliding() and detect_cliffs:
			direction = direction * -1
			$Sprite.flip_h = not $Sprite.flip_h
			$floor_checker.position.x = $CollisionShape2D.shape.get_extents().x * direction
	
	velocity.y += 20
	
	velocity.x = speed * direction
	
	velocity = move_and_slide(velocity,Vector2.UP)


func _on_top_checker_body_entered(body):
	is_dead = true
	#$AnimatedSprite.play("squashed")
	speed = 0
	set_collision_layer_bit(4, false)
	set_collision_mask_bit(0, false)
	$top_checker.set_collision_layer_bit(4, false)
	$top_checker.set_collision_mask_bit(0, false)
	$sides_checker.set_collision_layer_bit(4, false)
	$sides_checker.set_collision_mask_bit(0, false)
	$Timer.start()
	if body.name == "Scrub":
		body.bounce()

func _on_sides_checker_body_entered(body):
	if body.name == "Scrub":
		print ("ouch!")
		body.ouch(position.x)


func _on_Timer_timeout():
	queue_free()

func fireball_dead():
	is_dead = true
	$AnimatedSprite.play("fireballdead")
	speed = 0
	set_collision_layer_bit(4, false)
	set_collision_mask_bit(0, false)
	$top_checker.set_collision_layer_bit(4, false)
	$top_checker.set_collision_mask_bit(0, false)
	$sides_checker.set_collision_layer_bit(4, false)
	$sides_checker.set_collision_mask_bit(0, false)
	$Timer.start()
