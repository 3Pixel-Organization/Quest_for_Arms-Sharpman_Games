extends StaticBody2D

var bullet = preload("res://Scenes/bulletrg.tscn")
var bulletCount = 0
var canfire = true

var Timer = 0

func _physics_process(_delta):
	
	Timer += 1 
	
	if Timer > 50: 
		Timer = 0
		bulletCount = 0
		
	if Timer < 50 && bulletCount < 1: 
		
		var b = bullet.instance()
		if canfire == true:
			get_parent().add_child(b)
			b.global_position = $Position2D.global_position
			bulletCount += 1
			$Timer2.start()
			canfire = false

func _on_Timer2_timeout():
	canfire = true
