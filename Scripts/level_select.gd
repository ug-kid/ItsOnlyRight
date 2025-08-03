extends Control

const LEVEL_BTN = preload("res://Scenes/level_button.tscn")
var lvl_unlocked = Progress.progress
@export_dir var dir_path
@onready var grid = $ColorRect/MarginContainer/VBoxContainer/GridContainer

func _ready() -> void:
	BgMusic.volume_db = -5
	if Progress.progress == null:
		Progress.progress = 1
		print("initialized")
	get_levels(dir_path)
	unlock_levels()

func get_levels(path):
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			print(file_name)
			create_level_btn('%s/%s' % [dir.get_current_dir(), file_name], file_name)
			file_name = dir.get_next()
		dir.list_dir_end()
	else:
		print("An error occurred when trying to access the path.")

func create_level_btn(lvl_path, lvl_name):
	var btn = LEVEL_BTN.instantiate()
	btn.text = lvl_name.trim_suffix('.remap').trim_suffix('.tscn').replace("_", " ")
	btn.level_path = lvl_path.trim_suffix('.remap')
	btn.disabled = true
	grid.add_child(btn)

func unlock_levels():
	var lvlcheck = 0
	for btn in grid.get_children():
		if lvlcheck < lvl_unlocked:
			btn.disabled = false
		lvlcheck += 1
