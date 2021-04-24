extends Button

var level = 1

func level_1():
	level = 1

func level_2():
	level = 2

func level_3():
	level = 3


func _on_Button2_pressed():
	get_tree().quit()


func _on_Button_pressed():
	if level == 1:
		get_tree().change_scene("res://Scenes/Level1.tscn")
	elif level == 2:
		pass
		#get_tree().change_scene(diretorio do niv2)
	elif level == 3:
		pass
		#get_tree().change_scene(diretorio do niv3)
