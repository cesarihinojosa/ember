extends CharacterBody2D

const MAX_SPEED = 230.0
const ACCELERATION = 1500.0
const FRICTION = 1200.0
const JUMP_VELOCITY = -350.0
const FALL_GRAVITY_MULTIPLIER = 1.3
const JUMP_RELEASE_MULTIPLIER = 2.5
const COYOTE_TIME = 0.15
const JUMP_BUFFER_TIME = 0.1

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var coyote_timer = 0.0
var jump_buffer_timer = 0.0

func _physics_process(delta):
	# Gravity
	if not is_on_floor():
		var airborne_gravity = gravity
		if velocity.y > 0:
			airborne_gravity *= FALL_GRAVITY_MULTIPLIER
		elif velocity.y < 0 and not Input.is_action_pressed("ui_accept"):
			airborne_gravity *= JUMP_RELEASE_MULTIPLIER
		velocity.y += airborne_gravity * delta

	# Timers
	if is_on_floor():
		coyote_timer = COYOTE_TIME
	else:
		coyote_timer -= delta

	if Input.is_action_just_pressed("ui_accept"):
		jump_buffer_timer = JUMP_BUFFER_TIME
	else:
		jump_buffer_timer -= delta

	# Jump
	if jump_buffer_timer > 0 and coyote_timer > 0:
		velocity.y = JUMP_VELOCITY
		coyote_timer = 0.0
		jump_buffer_timer = 0.0

	# Horizontal movement
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction != 0:
		velocity.x = move_toward(velocity.x, direction * MAX_SPEED, ACCELERATION * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, FRICTION * delta)

	move_and_slide()
