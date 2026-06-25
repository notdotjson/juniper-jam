extends CharacterBody3D

const MAX_SPEED := 3.0
const RUN_MOD := 1.5
const JUMP_SPEED := 3.0
const ACCELERATION := 2.0
const DECELERATION := 3.0
const LOOK_SENS := 0.002

var old_move_dir := Vector3.ZERO

var rotation_sync: RotationSynchronizer


#TODO: move to rotation_synch.gd mayb
var timed_rotation := false
var timer := 0.0
const TARGET_TIME := 5.0

@onready var camera = $"Camera3D"
@onready var gravity = -ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	rotation_sync = RotationSynchronizer.new()

func _physics_process(_delta):

	#TODO: ditto
	if(timed_rotation):
		timer += _delta
		print(timer, " | ", _delta)
		if(timer >= TARGET_TIME):
			print("target time hit!")
			rotation_sync.begin_rotation(-rotation_sync.rotation_axis)
			timed_rotation = false
			timer = 0.0


	if rotation_sync.is_rotating:
		rotation_sync.step()
		global_rotate(-rotation_sync.rotation_axis, rotation_sync.get_tick_radians())
		if(rotation_sync.get_tick_degrees() == 0.0):
			var eul_basis = global_basis.get_euler()
			print(Vector3(rad_to_deg(eul_basis.x), rad_to_deg(eul_basis.y), rad_to_deg(eul_basis.z)))
			global_basis = Basis.from_euler(Vector3(eul_basis.x, eul_basis.y, 0.0)) #this is kind of a bandaid fix but it'll ship c:

		#print(global_transform.basis)

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

		var raw_cam_basis_z = camera.global_transform.basis.z
		var cam_basis_z := Vector3(round(raw_cam_basis_z.x), round(raw_cam_basis_z.y), round(raw_cam_basis_z.z))
		if cam_basis_z.length_squared() > 1.0:
			if cam_basis_z.z > 0:
				cam_basis_z -= Vector3.MODEL_FRONT
			elif cam_basis_z.z < 0:
				cam_basis_z += Vector3.MODEL_FRONT

		var raw_cam_basis_x = camera.global_transform.basis.x
		var cam_basis_x := Vector3(round(raw_cam_basis_x.x), round(raw_cam_basis_x.y), round(raw_cam_basis_x.z))
		if cam_basis_x.length_squared() > 1.0:
			if cam_basis_x.x > 0:
				cam_basis_x -= Vector3.MODEL_LEFT
			if cam_basis_x.x < 0:
				cam_basis_x += Vector3.MODEL_LEFT
		
		if event is InputEventMouseMotion:
			global_rotate(Vector3.UP, -event.relative.x * LOOK_SENS)
			camera.rotate_x(-event.relative.y * LOOK_SENS)
			camera.rotation.x = clampf(camera.rotation.x, deg_to_rad(-80), deg_to_rad(80))

			

		if !rotation_sync.is_rotating:
			if event.is_action_pressed("rotate_map_left"):
				rotation_sync.begin_rotation(cam_basis_z)
			elif event.is_action_pressed("rotate_map_right"):
				rotation_sync.begin_rotation(-cam_basis_z)
			elif event.is_action_pressed("rotate_map_forward"):
				rotation_sync.begin_rotation(-cam_basis_x)
			elif event.is_action_pressed("rotate_map_backward"):
				rotation_sync.begin_rotation(cam_basis_x)

			if(!timed_rotation):
				if event.is_action_pressed("rotate_map_interaction"):
					rotation_sync.begin_rotation(Vector3.MODEL_FRONT)
					timed_rotation = true

			#if event.is_action_pressed("rotate_map_left"):
			#	rotation_sync.begin_rotation(Vector3.MODEL_FRONT)
			#elif event.is_action_pressed("rotate_map_right"):
			#	rotation_sync.begin_rotation(Vector3.MODEL_REAR)
			#elif event.is_action_pressed("rotate_map_forward"):
			#	rotation_sync.begin_rotation(Vector3.MODEL_LEFT)
			#elif event.is_action_pressed("rotate_map_backward"):
			#	rotation_sync.begin_rotation(Vector3.MODEL_RIGHT)
		
		if event.is_action_pressed("debug_respawn"):
			global_position = Vector3(0, 0, 0)
			global_basis = Basis.from_euler(Vector3(0,0,0))
		
		if event.is_action_pressed("quit"):
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	elif event is InputEventMouseButton:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
