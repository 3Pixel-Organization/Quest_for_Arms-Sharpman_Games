class_name Level
extends Node


export var next_scene: String

onready var scrub: ScrubPlayer = $"Scrub"
onready var cutscene_player: AnimationPlayer = get_node_or_null("CutscenePlayer")


func _ready() -> void:
	assert(scrub, "where scrumble???")
	get_tree().paused = false
	
	if (GlobalVariables.checkpoint["Level"] == name):
		scrub.velocity = Vector2.ZERO
		scrub.global_position = GlobalVariables.checkpoint["Position"]
	elif cutscene_player and cutscene_player.has_animation("StartLevel"):
		cutscene_player.play("StartLevel")


func fake_input(action: String, strength: float = 1) -> void:
	Input.action_press(action, strength)


func next_level() -> void:
	var scene_changed := get_tree().change_scene(next_scene) as int
	assert(scene_changed == OK, "Couldn't change level")


func save_player_data() -> void:
	GlobalVariables.player = {
		"Gun": scrub.has_fireball,
		"Coins": scrub.coins,
	}


func _on_EndLevelPortal_body_entered(body: ScrubPlayer,
		cutscene: bool = false) -> void:
	if not body:
		return
	
	save_player_data()
	
	if cutscene:
		cutscene_player.play("EndLevel")
	else:
		next_level()


func _on_Fallzone_body_entered(body: PhysicsBody2D) -> void:
	if body is ScrubPlayer:
		scrub.emit_signal("death", 0.5)
	else:
		body.queue_free()


func _on_CutsceneCheckpoint_body_entered(body: ScrubPlayer,
		cutscene: String = "LevelOverview") -> void:
	if not body:
		return
	
	cutscene_player.play(cutscene)
