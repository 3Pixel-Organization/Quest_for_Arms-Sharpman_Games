extends StaticBody2D

const cannon_ball = preload("res://Scenes/CannonBall.tscn")
var bullet_on_screen = false

func _on_Clock_timeout():
	var ball = cannon_ball.instance()
	get_parent().add_child(ball)
	ball.global_position = $Position2D.global_position
	ball.velocity.x = -5 ## needs to be changed later
