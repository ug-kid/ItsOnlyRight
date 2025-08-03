extends Button

var original_size := scale
var grow_size := Vector2(1.1, 1.1)

## Button Functionality
func _on_pressed() -> void:
	if get_tree().paused:
		get_tree().paused = false
	get_tree().reload_current_scene()

func _process(_delta: float) -> void:
	if Input.is_action_pressed("restart"):
		if get_tree().paused:
			get_tree().paused = false
		get_tree().reload_current_scene()
