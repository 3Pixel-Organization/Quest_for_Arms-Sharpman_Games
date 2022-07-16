extends KinematicBody2D 


var original_pos: Vector2 = Vector2.ZERO
var original_collision_layer: int = collision_layer

export var falling_velocity: Vector2 = Vector2(0, 500)

onready var animation_player: AnimationPlayer = $"AnimationPlayer"
onready var shake_timer: Timer = $"ShakeTimer"
onready var respawn_timer: Timer = $"RespawnTimer"
onready var top_checker: Area2D = $"TopChecker"


func _ready() -> void:
	set_physics_process(false)
	original_pos = global_position


func _physics_process(delta: float) -> void:
	var collision_data := move_and_collide(
			falling_velocity * delta) as KinematicCollision2D
	
	assert(not collision_data, "???? should not collide with anything")


func _on_TopChecker_body_entered(body: ScrubPlayer ) -> void:
	if not body:
		return
	
	top_checker.set_deferred("monitoring", false)
	animation_player.play("Shake")
	shake_timer.start() # Maybe should just queue shake like 4 times
	respawn_timer.start()


func _on_ShakeTimer_timeout() -> void:
	animation_player.stop()
	set_deferred("collision_layer", 0)
	set_physics_process(true)


func _on_RespawnTimer_timeout() -> void:
	set_physics_process(false)
	top_checker.set_deferred("monitoring", true)
	set_deferred("collision_layer", original_collision_layer)
	global_position = original_pos
