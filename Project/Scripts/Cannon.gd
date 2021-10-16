extends StaticBody2D

export var projectile_scene: PackedScene
export var projectile_speed: float

# Needs to be onready otherwise gets assigned to nothing
onready var projectile: Resource = load(projectile_scene.resource_path)
onready var player: ScrubPlayer = get_tree().current_scene.find_node("Scrub")


func _on_Clock_timeout():
	if $"VisibilityEnabler2D".is_on_screen():
		var projectile_instance = projectile.instance()
		projectile_instance.global_position = $"ProjectileOrigin".global_position
		projectile_instance.velocity.x = projectile_speed * (1.0 - 2.0 * (player.global_position.x < global_position.x) as float)
		get_tree().current_scene.add_child(projectile_instance)
