extends CharacterBody3D

const MAX_SPEED = 3
const RUN_MOD = 1.5
const JUMP_SPEED = 3
const ACCELERATION = 2
const DECELERATION = 3
const LOOK_SENS = 0.002

var _old_move_dir = Vector3.ZERO

var rotation_sync: RotationSynchronizer

@onready var camera = $"Camera3D"
@onready var gravity = -ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	rotation_sync = RotationSynchronizer.new()


func _physics_process(delta):
	if rotation_sync.is_rotating:
		rotation_sync.step()
		global_rotate(-rotation_sync.direction, rotation_sync.get_tick_radians())

	
	var move_dir = Vector3()
	if is_on_floor():
		move_dir.x = Input.get_axis(&"move_left", &"move_right")
		move_dir.z = Input.get_axis(&"move_forward", &"move_backward")
	
	var cam_basis = camera.global_transform.basis
	cam_basis = cam_basis.rotated(cam_basis.x, -cam_basis.get_euler().x)
	move_dir = cam_basis * move_dir
	

	if move_dir.length_squared() > 1:
		move_dir /= move_dir.length()
	
	velocity.y += delta * gravity
	
	var hvel = velocity
	hvel.y = 0
	
	var target = _old_move_dir * MAX_SPEED
	if Input.is_action_pressed("run"):
		target = _old_move_dir * MAX_SPEED * RUN_MOD
	var accel
	if _old_move_dir.dot(hvel) > 0:
		accel = ACCELERATION
	elif is_on_floor():
		accel = DECELERATION
	else:
		accel = 0

	hvel = hvel.lerp(target, accel * delta)
	
	velocity.x = hvel.x
	velocity.z = hvel.z
	
	if is_on_floor() and Input.is_action_just_pressed(&"jump"):
		velocity.y = JUMP_SPEED
		
	
	move_and_slide()

	if is_on_floor():
		_old_move_dir = move_dir
	
	

func _input(event: InputEvent) -> void:
	if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		
		if event is InputEventMouseMotion:
			global_rotate(Vector3.UP, -event.relative.x * LOOK_SENS)
			camera.rotate_x(-event.relative.y * LOOK_SENS)
			camera.rotation.x = clampf(camera.rotation.x, deg_to_rad(-80), deg_to_rad(80))

		if !rotation_sync.is_rotating:
			if event.is_action_pressed("rotate_map_right"):
				rotation_sync.begin_rotation(Vector3.FORWARD)
		
		if event.is_action_pressed("debug_respawn"):
			global_position = Vector3(0, 0, 0)
		
		if event.is_action_pressed("quit"):
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	elif event is InputEventMouseButton:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
			
