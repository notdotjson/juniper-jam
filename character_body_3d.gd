extends CharacterBody3D

const MAX_SPEED = 3
const JUMP_SPEED = 5
const ACCELERATION = 4
const DECELERATION = 4
const LOOK_SENS = 0.002

var _old_move_dir = Vector3.ZERO

var _target = basis
var _lockout = false
var _rotation_timer = 0.0

#var debug_count = 0

@onready var camera = $"Camera3D"
@onready var gravity = -ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(delta):

	if _lockout:
		if basis != _target:
			basis = lerp(basis, _target, "0.05")
			_rotation_timer += delta
			print("rotating!! t: ", _rotation_timer)
		if _rotation_timer >= 1.8:
			basis = _target
			_rotation_timer = 0.0
			_lockout = false
			print("rotation finished, lockout cleared!")


	if Input.is_action_just_pressed(&"quit"):
		get_tree().quit()
	#if position.y < -50:
		#position = Vector3(0, 1, 0)
	
	var move_dir = Vector3()
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
		target = _old_move_dir * MAX_SPEED * 2
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
		#print("new jump! = ", velocity)
		#debug_count = 0
	#elif !is_on_floor():
		#debug_count += 1
		#print("physics step: ", debug_count, " = ", velocity)
		
	
	move_and_slide()

	_old_move_dir = move_dir
	
	

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * LOOK_SENS)
		camera.rotate_x(-event.relative.y * LOOK_SENS)
		camera.rotation.x = clampf(camera.rotation.x, deg_to_rad(-70), deg_to_rad(70))
	if !_lockout:
		if event.is_action_pressed("rotate_map_forward"):
			_target = _target.rotated(Vector3.FORWARD, deg_to_rad(-90))
			_lockout = true
			print("action detected, locked out of rotation!")
	if event.is_action_pressed("debug_respawn"):
			global_position = Vector3(0, 0, 0)
		
			
