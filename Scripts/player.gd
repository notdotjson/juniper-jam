extends CharacterBody3D

const MAX_SPEED = 3
const RUN_MOD = 1.5
const JUMP_SPEED = 3
const ACCELERATION = 2
const DECELERATION = 3
const LOOK_SENS = 0.002

var old_move_dir = Vector3.ZERO

var rotation_sync: RotationSynchronizer

var rot_lock: bool

@onready var camera = $"Camera3D"
@onready var gravity = -ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	rotation_sync = RotationSynchronizer.new()


func _physics_process(_delta):
	if rotation_sync.is_rotating:
		rotation_sync.step()
		quaternion *= rotation_sync.get_quaternion()
		
		
		


	
	var move_dir = Vector3()
	if is_on_floor():
		move_dir.x = Input.get_axis(&"move_left", &"move_right")
		move_dir.z = Input.get_axis(&"move_forward", &"move_backward")
	
	var cam_basis = camera.global_transform.basis
	cam_basis = cam_basis.rotated(cam_basis.x, -cam_basis.get_euler().x)
	move_dir = cam_basis * move_dir
	

	if move_dir.length_squared() > 1:
		move_dir /= move_dir.length()
	
	velocity.y += _delta * gravity
	
	var hvel = velocity
	hvel.y = 0
	
	var target = old_move_dir * MAX_SPEED
	if Input.is_action_pressed("run"):
		target = old_move_dir * MAX_SPEED * RUN_MOD
	var accel
	if old_move_dir.dot(hvel) > 0:
		accel = ACCELERATION
	elif is_on_floor():
		accel = DECELERATION
	else:
		accel = 0

	hvel = hvel.lerp(target, accel * _delta)
	
	velocity.x = hvel.x
	velocity.z = hvel.z
	
	if is_on_floor() and Input.is_action_just_pressed(&"jump"):
		velocity.y = JUMP_SPEED
		
	
	move_and_slide()

	if is_on_floor():
		old_move_dir = move_dir
	
	

func _input(event: InputEvent) -> void:
	if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:

		if event is InputEventMouseMotion:
			global_rotate(Vector3.UP, -event.relative.x * LOOK_SENS)
			camera.rotate_x(-event.relative.y * LOOK_SENS)
			camera.rotation.x = clampf(camera.rotation.x, deg_to_rad(-80), deg_to_rad(80))

		if !rotation_sync.is_rotating:
			if event.is_action_pressed("rotate_map_left"):
				rotation_sync.begin_rotation(Vector3.MODEL_FRONT)
				#rotation_sync.rotate(90.0, Vector3.MODEL_FRONT)
				pass
				#rotation_sync.begin_rotation(Vector3.MODEL_FRONT)
			elif event.is_action_pressed("rotate_map_right"):
				#rotation_sync.begin_rotation(Vector3.MODEL_REAR)
				pass
			elif event.is_action_pressed("rotate_map_forward"):
				#rotation_sync.begin_rotation(Vector3.MODEL_RIGHT)
				pass
			elif event.is_action_pressed("rotate_map_backward"):
				#rotation_sync.begin_rotation(Vector3.MODEL_LEFT)
				pass
		
		if event.is_action_pressed("debug_respawn"):
			global_position = Vector3(0, 0, 0)
		
		if event.is_action_pressed("quit"):
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	elif event is InputEventMouseButton:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

#Rotating around axis: (0.0, 0.0, 1.0) | Player's normalized direction is: (-0.025997, -0.004, 0.999654)	front	(0, 0, 1) Vector3.MODEL_FRONT
#Rotating around axis: (0.0, 0.0, 1.0) | Player's normalized direction is: (0.996238, -0.025997, 0.082674)	left	(1, 0, 0) 
#Rotating around axis: (0.0, 0.0, 1.0) | Player's normalized direction is: (0.077515, 0.0, -0.996991)		back	(0, 0 -1) Vector3.FORWARD
#Rotating around axis: (0.0, 0.0, 1.0) | Player's normalized direction is: (-0.999759, 0.012, -0.018387)	right	(-1, 0, 0)
#Rotating around axis: (0.0, 0.0, 1.0) | Player's normalized direction is: (0.017611, -0.984808, -0.172753)	up		(0 -1, 0)
#Rotating around axis: (0.0, 0.0, 1.0) | Player's normalized direction is: (0.008608, 0.984808, -0.173435)	down	(0, 1, 0)
