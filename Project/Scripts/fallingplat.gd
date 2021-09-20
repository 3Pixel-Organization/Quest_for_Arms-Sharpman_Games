extends KinematicBody2D 

var velocity: Vector2 = Vector2()

onready var animation_player := $"AnimationPlayer"
onready var shake_timer := $"ShakeTimer"
onready var visibility_notifier := $"VisibilityNotifier2D"
onready var top_checker := $"TopChecker"


func _ready():
	set_physics_process(false)


func _physics_process(delta):
# warning-ignore:return_value_discarded
	move_and_collide(velocity * delta)


func _on_TopChecker_body_entered(body):
	if body is ScrubPlayer:
		top_checker.set_deferred("monitoring", false)
		animation_player.play("Shake")
		var err = visibility_notifier.connect("screen_exited", self, "_on_screen_exited")
		assert(err == OK)
		shake_timer.start()


func _on_ShakeTimer_timeout():
	$CollisionShape2D.disabled = true
	set_physics_process(true)
	velocity.y = 500


func _on_screen_exited():
	queue_free()
