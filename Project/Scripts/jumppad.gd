extends Area2D

func _ready():
	pass

func _on_jumppad_body_entered(body):
	if body.name == "Scrub":
		body._jump_pad()
