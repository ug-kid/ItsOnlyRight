class_name CarStateMachine extends Node

var states: Array[State]
var prev_state: State
var curr_state: State

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	process_mode = Node.PROCESS_MODE_DISABLED

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	ChangeState(curr_state.Process(delta))

func _physics_process(delta: float) -> void:
	ChangeState(curr_state.Physics(delta))

func _unhandled_input(event: InputEvent) -> void:
	ChangeState(curr_state.HandleInput(event))

func Initialize(_car: Car) -> void:
	states = []
	#puts states into states array
	for c in get_children():
		if c is State:
			states.append(c)
	
	if states.size() > 0:
		states[0].car = _car
		ChangeState(states[0])
		process_mode = Node.PROCESS_MODE_INHERIT

func ChangeState(new_state: State) -> void:
	#does nothing if new state is current state
	if new_state == null || new_state == curr_state:
		return
	#exits current state
	if curr_state:
		curr_state.Exit()
	#enters new state
	prev_state = curr_state
	curr_state = new_state
	curr_state.Enter()
