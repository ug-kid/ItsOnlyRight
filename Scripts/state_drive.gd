class_name State_Drive extends State

@onready var state_drift: State_Drift = $"../State_Drift"
@onready var state_idle: State_Idle = $"../State_Idle"

const DRIVE_TRACTION = 10
const DRIVE_STEERING_ANGLE = 5.0

# What happens when car enters this state
func Enter() -> void:
	pass

# What happens when car leaves state
func Exit() -> void:
	pass

func Process(_delta: float) -> State:
	return null

func Physics(_delta: float) -> State:
	if car.lvl_finished:
		return state_idle
	if car.valid_drift():
		return state_drift
	car.get_input(DRIVE_STEERING_ANGLE)
	car.apply_friction(_delta)
	car.calculate_steering(_delta, DRIVE_TRACTION)
	car.velocity += car.acceleration * _delta
	car.move_and_slide()
	car.engine_sound()
	return null

func HandleInput(_event: InputEvent) -> State:
	return null
