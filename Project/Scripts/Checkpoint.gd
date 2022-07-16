extends Area2D


export var play_cutscene: bool = false
export var cutscene_name: String = "LevelOverview"

onready var level: Node = get_tree().current_scene
onready var index: int = get_index()	# Does not allow for checkpoints
										# created dynamically


func _ready() -> void:
	if (GlobalVariables.checkpoint["Level"] == level.name and
			index <= GlobalVariables.checkpoint["Index"]):
		return
	
	var checkpoint_ready: int = connect("body_entered", self,
			"_on_Area2D_body_entered", [], CONNECT_ONESHOT)
			# The signal in oneshot because the checkpoint
			# shouldn't trigger more than once
	
	assert(checkpoint_ready == OK, "Checkpoint collision signal couldn't connect")
	
	if not play_cutscene:
		return
	
	var cutscene_ready: int = connect("body_entered", level,
			"_on_CutsceneCheckpoint_body_entered", [cutscene_name],
			CONNECT_ONESHOT)
	
	assert(cutscene_ready == OK, "Cutscene collision signal couldn't connect")


func _on_Area2D_body_entered(body: ScrubPlayer) -> void:
	if not body:
		return
	
	GlobalVariables.checkpoint = {
		"Level": level.name,
		"Position": global_position,
		"Index": index,
	}
	
	GlobalVariables.player = {
		"Gun": level.scrub.has_fireball,
		"Coins": level.scrub.coins,
	}
