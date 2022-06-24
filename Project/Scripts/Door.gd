extends KinematicBody2D


onready var activation_area: Area2D = $".."

var speed: Vector2 = Vector2.DOWN * 100
var closed_height: float
var open_height: float

func _ready() -> void:
	closed_height = position.y
	open_height = closed_height - 48
	set_physics_process(false)


func _physics_process(delta: float) -> void:
	var _collision := move_and_collide(speed * delta) as KinematicCollision2D
	if position.y > max(open_height, closed_height):
		position.y = closed_height
	
	if position.y < min(open_height, closed_height):
		position.y = open_height

func _on_Door_body_entered(body: ScrubPlayer) -> void:
	if not body:
		return
	
	speed.y *= -1
	set_physics_process(true)


func _on_Door_body_exited(body: ScrubPlayer) -> void:
	if not body:
		return
	
	if activation_area.get_overlapping_bodies().size() <= 0:
		speed.y *= -1
		set_physics_process(true)
