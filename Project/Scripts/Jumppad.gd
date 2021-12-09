extends Area2D

func _on_Jumppad_body_entered(body: ScrubPlayer):
	body._jump_pad()
