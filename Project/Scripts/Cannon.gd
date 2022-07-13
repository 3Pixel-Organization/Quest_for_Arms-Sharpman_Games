extends StaticBody2D


enum DIRECTION {
	LEFT = -1,
	RIGHT = 1,
}

export var projectile_scene: PackedScene
export var projectile_speed: float
export(DIRECTION) var direction: int = DIRECTION.LEFT

onready var projectile: Resource = load(projectile_scene.resource_path)
onready var sprite: Sprite = $"Sprite"
onready var clock: Timer = $"Clock"
onready var detection_area: Area2D = get_node_or_null("DetectionArea")


func _ready() -> void:
	set_process(false)
	if detection_area:
		
		var connected := detection_area.connect("body_entered", self, "_clock_start") as int
		assert(connected == OK)
		
		connected = detection_area.connect("body_exited", self, "_clock_stop") as int
		assert(connected == OK)
		
		clock.stop()
	
	scale.x = direction * -1


func _clock_start(_body: ScrubPlayer) -> void:
	clock.start()


func _clock_stop(_body: ScrubPlayer) -> void:
	if detection_area.get_overlapping_bodies().size() <= 0:
		clock.stop()


func _on_Clock_timeout() -> void:
	if $"VisibilityEnabler2D".is_on_screen() or detection_area:
		var projectile_instance = projectile.instance()
		projectile_instance.global_position = $"ProjectileOrigin".global_position
		projectile_instance.velocity.x = projectile_speed * direction
		get_tree().current_scene.add_child(projectile_instance)
