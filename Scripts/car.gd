class_name Car extends CharacterBody2D

@onready var car_state_machine: CarStateMachine = $CarStateMachine

const DRIFT_SPEED = 400
const TINY_TURBO_CHARGE_TIME = 2
const TINY_TURBO_DURATION = 1
const TINY_TURBO_POWER = 750
const BASE_ENGINE_POWER = 1000
@export var lvl_finished = false
var wheel_base = 44
var engine_power = BASE_ENGINE_POWER
var friction = -55
var drag = -0.06
var braking = -450
var max_speed_reverse = 75
var tiny_turbo_ready = false
var acceleration = Vector2.ZERO
var steer_direction
var steer_bias = 0.5

func _ready():
	$DeAccelSFX.play()
	car_state_machine.Initialize(self)
	velocity = Vector2.ZERO
	$TinyTurboFLame.hide()
	$TinyTurboFLame.play()

func _physics_process(_delta) -> void:
	acceleration = Vector2.ZERO

func valid_drift():
	if Input.is_action_pressed("drift") and velocity.length() > DRIFT_SPEED:
		return true
	else:
		return false

func call_drift_trail():
	var drift_origin_left = position - transform.x * wheel_base / 2.0 + transform.y * 10
	var drift_origin_right = position - transform.x * wheel_base / 2.0 - transform.y * 10
	$DriftTrailLeft.drift_trail(drift_origin_left)
	$DriftTrailRight.drift_trail(drift_origin_right)
	
func apply_friction(delta):
	if acceleration == Vector2.ZERO and velocity.length() < 20:
		velocity = Vector2.ZERO
	var friction_force = velocity * friction * delta
	var drag_force = velocity * velocity.length() * drag * delta
	acceleration += drag_force + friction_force
	
func get_input(steering_angle):
	var turn = Input.get_axis("steer_left", "steer_right") + steer_bias
	steer_direction = turn * deg_to_rad(steering_angle)
	if Input.is_action_pressed("accelerate"):
		acceleration = transform.x * engine_power
	if Input.is_action_pressed("brake"):
		acceleration = transform.x * braking
	
func calculate_steering(delta, traction):
	var rear_wheel = position - transform.x * wheel_base / 2.0
	var front_wheel = position + transform.x * wheel_base / 2.0
	rear_wheel += velocity * delta
	front_wheel += velocity.rotated(steer_direction) * delta
	var new_heading = rear_wheel.direction_to(front_wheel)
	var d = new_heading.dot(velocity.normalized())
	if d > 0:
		velocity = lerp(velocity, new_heading * velocity.length(), traction * delta)
	if d < 0:
		velocity = -new_heading * min(velocity.length(), max_speed_reverse)
	rotation = new_heading.angle()

func engine_sound():
	var speed = velocity.length()
	$DeAccelSFX.pitch_scale = clamp(speed/200, 1, 2.5)

func _on_drift_start() -> void:
	$DriftSFX.play()
	$TinyTurboCharge.start(TINY_TURBO_CHARGE_TIME)
	tiny_turbo_ready = false

func _on_tiny_turbo_timeout() -> void:
	# add some animations!!!
	tiny_turbo_ready = true
	$TinyTurboSFX.play()
	pass

func _on_drift_end() -> void:
	$TinyTurboCharge.stop()
	$DriftSFX.stop()
	if tiny_turbo_ready == true:
		tiny_turbo()

func tiny_turbo():
	# add animation & sound
	$TinyTurboBoost.start(TINY_TURBO_DURATION)
	$TinyTurboFLame.show()
	$DeAccelSFX.volume_db += 2.5
	engine_power += TINY_TURBO_POWER
	steer_bias = 0
	print("Tiny Turbo Activated!")

func _on_tiny_turbo_boost_timeout() -> void:
	$DeAccelSFX.volume_db -= 2.5
	$TinyTurboFLame.hide()
	engine_power = BASE_ENGINE_POWER
	steer_bias = 0.5
