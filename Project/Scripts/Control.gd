extends Control


func _process(delta):
	if Input.is_action_pressed("Pause"):
		visible = true
		get_tree().paused = true

func _on_Button_pressed():
	hide()
	get_tree().paused = false

func _on_Button2_pressed():
	get_tree().paused = false
	get_tree().quit()
