extends StaticBody2D


enum Direction {
	LEFT = -1,
	RIGHT = 1,
}

export var projectile_scene: PackedScene
export var projectile_speed: float
export(Direction) var direction: int = Direction.LEFT

onready var projectile: Resource = load(projectile_scene.resource_path)
onready var sprite: Sprite = $"Sprite"
onready var clock: Timer = $"Clock"
onready var projectile_origin: Position2D = $"ProjectileOrigin"
onready var detection_area: Area2D = get_node_or_null("DetectionArea")

func _ready() -> void:
	if detection_area:
		
		var connected := detection_area.connect("body_entered", self,
				"_clock_start") as int
		assert(connected == OK)
		
		connected = detection_area.connect("body_exited", self,
				"_clock_stop") as int
		assert(connected == OK)
		
		clock.stop()
	
	sprite.flip_h = direction > 0
	projectile_origin.position.x *= -direction


func _clock_start(_body: ScrubPlayer) -> void:
	clock.start()


func _clock_stop(_body: ScrubPlayer) -> void:
	if detection_area.get_overlapping_bodies().size() <= 0:
		clock.stop()


func _on_Clock_timeout() -> void:
	if $"VisibilityEnabler2D".is_on_screen() or detection_area:
		var projectile_instance = projectile.instance()
		projectile_instance.global_position = projectile_origin.global_position
		projectile_instance.velocity.x = projectile_speed * direction
		projectile_instance.spawner = self
		get_tree().current_scene.add_child(projectile_instance)
