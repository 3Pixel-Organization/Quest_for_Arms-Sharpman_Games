extends Area2D

onready var animation_player: AnimationPlayer = $"AnimationPlayer"
onready var sound: AudioStreamPlayer = $"Sound"


func _on_Coin_body_entered(body: ScrubPlayer) -> void:
	if not body:
		return
	
	body.coins += 1
	animation_player.play("Bounce")
	set_deferred("monitoring", false)
	sound.play()


func _on_Sound_finished() -> void:
	queue_free()
