extends Control

func _on_timer_timeout() -> void:
	$AnimationPlayer.play("car_swoop")
