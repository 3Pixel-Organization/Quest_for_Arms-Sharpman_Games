extends Node2D

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
	visible = false
	$Button2.disabled = true
	$Button.disabled = true


func _on_Button2_pressed():
	get_tree().quit()


func _on_Button_pressed():
	get_tree().reload_current_scene()


func _on_Timer_timeout():
	$AudioStreamPlayer.stop()
	hassfx = false
