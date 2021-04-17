extends Control


func _ready():
	pass


func _on_Button2_pressed():
	OS.shell_open("https://3-pixel.com/")


func _on_Button3_pressed():
	get_tree().quit()
