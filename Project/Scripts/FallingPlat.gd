extends KinematicBody2D 


export var falling_velocity: Vector2 = Vector2(0, 500)

onready var animation_player: AnimationPlayer = $"AnimationPlayer"
onready var shake_timer: Timer = $"ShakeTimer"
onready var visibility_notifier: VisibilityNotifier2D = $"VisibilityNotifier2D"
onready var top_checker: Area2D = $"TopChecker"


func _ready() -> void:
	set_physics_process(false)


func _physics_process(delta: float) -> void:
# warning-ignore:return_value_discarded
	move_and_collide(falling_velocity * delta)


func _on_TopChecker_body_entered(body: ScrubPlayer ) -> void:
	if not body: return
	
	top_checker.set_deferred("monitoring", false)
	animation_player.play("Shake")
	var err: int = visibility_notifier.connect("screen_exited", self, "_on_screen_exited")
	assert(err == OK)
	shake_timer.start()


func _on_ShakeTimer_timeout() -> void:
	($"CollisionShape2D" as CollisionShape2D).disabled = true
	set_physics_process(true)


func _on_screen_exited() -> void:
	queue_free()
