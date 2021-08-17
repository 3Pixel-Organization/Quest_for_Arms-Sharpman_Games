extends VideoPlayer

func _ready():
	pass

func _on_VideoPlayer_finished():
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Scenes/MainMenu.tscn")

func _process(_delta):
	if Input.is_action_pressed("ui_accept"):
# warning-ignore:return_value_discarded
		get_tree().change_scene("res://Scenes/MainMenu.tscn")
