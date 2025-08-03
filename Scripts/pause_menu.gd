extends Control

func _ready():
	hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if !$"../../..".lvl_finished and Input.is_action_just_released("pause"):
		get_tree().paused = !get_tree().paused
		self.visible = !self.visible
		if BgMusic.volume_db == -5:
			BgMusic.volume_db = -15
		else:
			BgMusic.volume_db = -5
