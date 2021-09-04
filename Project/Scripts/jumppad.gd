extends Area2D

func _on_Jumppad_body_entered(body):
	if body.name == "Scrub":
		body._jump_pad()
