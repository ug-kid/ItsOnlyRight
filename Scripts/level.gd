class_name Level extends Node2D

@export var start_pos: Vector2
@export_file() var next_lvl_path
@export var finish_line_pos: Vector2
@export var finish_line_scale: Vector2
@export var time_to_finish: float
@export var Layout: TileMapLayer
@export var lvl_number: int
@export var start_rotation: int
@onready var lvl_timer = $CanvasLayer/TimeLeftLabel/LevelTimer
var lvl_started = false
var lvl_finished = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$CanvasLayer/TimeLeftLabel.text = str(time_to_finish)
	$Car.position = start_pos
	$Car.rotation_degrees = start_rotation
	$FinishLineArea/CollisionShape2D.global_position = finish_line_pos
	$FinishLineArea/CollisionShape2D.scale = finish_line_scale
	$CanvasLayer/Control/Congrats_Sequence/VBoxContainer/LevelButton.level_path = next_lvl_path
	BgMusic.volume_db = -5
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if !lvl_started and $Car.velocity != Vector2.ZERO:
		lvl_started = true
		lvl_timer.start(time_to_finish)
		print("Race Started!")
	if lvl_started and !lvl_finished:
		$CanvasLayer/TimeLeftLabel.text = str(snappedf(lvl_timer.time_left,0.1))

func _on_finish_line_body_entered(_body: Node2D) -> void:
	if !lvl_finished and lvl_started:
		lvl_finished = true
		$WinSFX.play()
		$Car.lvl_finished = true
		lvl_timer.stop()
		print(lvl_number, Progress.progress)
		if lvl_number == Progress.progress:
			Progress.progress += 1
			print("success")
		$CanvasLayer/Control/Congrats_Sequence.show()
		print("Congrats!")

func game_over() -> void:
	lvl_finished = true
	$LoseSFX.play()
	$Car.lvl_finished = true
	$CanvasLayer/Control/LoseSequence.show()
	print("too slow!")
