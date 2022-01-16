extends StaticBody2D


enum DIRECTION {
	LEFT = -1,
	RIGHT = 1,
}

export var projectile_scene: PackedScene
export var projectile_speed: float
export(DIRECTION) var direction: int = DIRECTION.LEFT

# Needs to be onready otherwise gets assigned to nothing
onready var projectile: Resource = load(projectile_scene.resource_path)
onready var sprite: Sprite = $"Sprite"


func _ready() -> void:
	scale.x = direction * -1

func _on_Clock_timeout() -> void:
	if $"VisibilityEnabler2D".is_on_screen():
		var projectile_instance = projectile.instance()
		projectile_instance.global_position = $"ProjectileOrigin".global_position
		projectile_instance.velocity.x = projectile_speed * direction
		get_tree().current_scene.add_child(projectile_instance)
