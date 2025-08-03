class_name State_Drift extends State

signal drift_start
signal drift_end

@onready var state_drive: State_Drive = $"../State_Drive"
@onready var state_idle: State_Idle = $"../State_Idle"

const DRIFT_TRACTION = 0.5
const DRIFT_STEERING_ANGLE = 10.0
var steering_angle

func Enter() -> void:
	steering_angle = state_drive.DRIVE_STEERING_ANGLE
	emit_signal("drift_start")

func Exit() -> void:
	emit_signal("drift_end")
	pass

func Process(_delta: float) -> State:
	return null

func Physics(_delta: float) -> State:
	if car.lvl_finished:
		return state_idle
	if ! car.valid_drift():
		return state_drive
	if steering_angle < DRIFT_STEERING_ANGLE:
		steering_angle += 0.2
	car.get_input(DRIFT_STEERING_ANGLE)
	car.apply_friction(_delta)
	car.calculate_steering(_delta, DRIFT_TRACTION)
	car.velocity += car.acceleration * _delta
	car.move_and_slide()
	car.call_drift_trail()
	car.engine_sound()
	return null

func HandleInput(_event: InputEvent) -> State:
	return null
