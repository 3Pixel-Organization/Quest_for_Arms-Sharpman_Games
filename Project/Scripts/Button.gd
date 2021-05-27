extends Node2D

var level = 1
var hassfx = true

func visible():
	visible = true
	$Button2.disabled = false
	$Button.disabled = false
	if hassfx == true:
		$AudioStreamPlayer.play()
		$Timer.start()
		hassfx = false


func _ready():
	if get_tree().get_current_scene().get_name() == "Level 1":
		level = 1
	if get_tree().get_current_scene().get_name() == "Level 2":
		level = 2
	visible = false
	$Button2.disabled = true
	$Button.disabled = true


func _on_Button2_pressed():
	get_tree().quit()


func _on_Button_pressed():
	if level == 1:
		get_tree().change_scene("res://Scenes/Level1.tscn")
	elif level == 2:
		get_tree().change_scene("res://Scenes/Level2.tscn")
	elif level == 3:
		pass
		#get_tree().change_scene(diretorio do niv3)


func _on_Timer_timeout():
	$AudioStreamPlayer.stop()
	hassfx = false
