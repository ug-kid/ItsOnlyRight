extends Line2D

func _ready() -> void:
	default_color="000000"

func drift_trail(point):
	if points.size() > 5:
		remove_point(0)
	add_point(point)

func _on_tiny_turbo_charge_timeout() -> void:
	default_color="ff0000"

func _on_drift_end() -> void:
	clear_points()
	default_color="000000"
