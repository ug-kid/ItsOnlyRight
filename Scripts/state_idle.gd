class_name State_Idle extends State

const IDLE_TRACTION = 0.001

# What happens when car enters this state
func Enter() -> void:
	$"../../DeAccelSFX".volume_db = -15

# What happens when car leaves state
func Exit() -> void:
	pass

func Process(_delta: float) -> State:
	return null

func Physics(_delta: float) -> State:
	car.apply_friction(_delta)
	car.calculate_steering(_delta, IDLE_TRACTION)
	car.velocity += car.acceleration * _delta
	car.move_and_slide()
	car.engine_sound()
	return null

func HandleInput(_event: InputEvent) -> State:
	return null
