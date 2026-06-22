extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5

@onready var camera = $"Camera3D"

var camlook = 0.0

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _physics_process(delta: float) -> void:

	# reset position when falling off world
	if position.y <= -15:
		position = Vector3(0, 3, 0)

	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var user_input := Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var movement_direction := (transform.basis * Vector3(user_input.x, 0, user_input.y)).normalized()

	if movement_direction:
		velocity.x = movement_direction.x * SPEED
		velocity.z = movement_direction.z * SPEED
	else:
		#velocity = Vector3(move_toward(velocity.x, 0, SPEED), velocity.y, move_toward(velocity.z, 0, SPEED))
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	#var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	#var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	#if direction:
	#	velocity.x = direction.x * SPEED
	#	velocity.z = direction.z * SPEED
	#else:
	#	velocity.x = move_toward(velocity.x, 0, SPEED)
	#	velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()

func _input(event) -> void:
	if event is InputEventMouseMotion:
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			rotate_y(deg_to_rad(-event.relative.x * 0.3))
			camlook -= event.relative.y * 0.3
			camlook = clamp (camlook, -80, 80)
			camera.rotation_degrees.x = camlook
			#camera.rotate_x(deg_to_rad(-event.relative.y * 0.3))

	if event is InputEventKey:
		if event.keycode == KEY_ESCAPE:
			get_tree().quit()
