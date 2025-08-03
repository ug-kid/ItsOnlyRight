extends Button

@export_file var level_path

var original_size := scale
var grow_size := Vector2(1.1, 1.1)

## Button Functionality
func _on_lvl_button_pressed() -> void:
	if get_tree().paused:
		get_tree().paused = false
	if level_path == null:
		return
	get_tree().change_scene_to_file(level_path)
