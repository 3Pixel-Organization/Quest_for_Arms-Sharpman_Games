extends StaticBody2D

var bullet = preload("res://Scenes/bullet.tscn")
var bulletCount = 0

var Timer = 0

func _physics_process(delta):
	
	Timer += 1 
	
	if Timer > 50: 
		Timer = 0
		bulletCount = 0
		
	if Timer < 50 and bulletCount < 1: 
		
		var b = bullet.instance()
		
		get_parent().add_child(b)
		b.global_position = $Position2D.global_position
		bulletCount += 1
