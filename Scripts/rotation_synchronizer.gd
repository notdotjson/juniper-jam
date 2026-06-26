class_name RotationSynchronizer

static var is_rotating := false

static var target: float:
	set(target_angle):
		if !is_rotating:
			target = target_angle

static var increment: float:
	set(angle_increment):
		if !is_rotating:
			increment = angle_increment
	
static var deg_to_target := 0.0

static var degrees := 0.0

static var rotation_axis := Vector3.ZERO

static var is_timed := false

static var timer := 0.0

const TARGET_TIME := 5.0

func _init() -> void:
	target = 90.0
	increment = 2.5

func get_degrees_radians() -> float:
	return deg_to_rad(degrees)

func get_degrees() -> float:
	return degrees

func get_rotation_axis() -> Vector3:
	return rotation_axis

func begin_rotation(axis: Vector3, is_interaction: bool = false) -> void:
	if !is_timed:
		is_timed = is_interaction
		deg_to_target = 0.0
		is_rotating = true
		rotation_axis = axis

#should only ever be called in player.gd's physics process
func pass_local_ref(_delta: float, sync: RotationSynchronizer):
	if is_timed:
		timer += _delta
		print(timer)
		if(timer >= TARGET_TIME):
			print("target time hit!")
			is_timed = false
			timer = 0.0
			sync.begin_rotation(-sync.get_rotation_axis())

#should only ever be called in player.gd's physics process
func step() -> void:
	if is_rotating:
		if deg_to_target != target:
			degrees = increment
			deg_to_target += increment
		elif deg_to_target == target:
			degrees = 0.0
			is_rotating = false
