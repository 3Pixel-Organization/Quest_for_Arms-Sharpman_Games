extends Node


var tree: SceneTree = get_tree()


func _ready():
	tree.paused = false


func _on_StartGame_body_entered(_body: ScrubPlayer):
	GlobalVariables.player["Gun"] = false
	var scene_changed: int = tree.change_scene("res://Scenes/Intro.tscn")
	assert(scene_changed == OK)
