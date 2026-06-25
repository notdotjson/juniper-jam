class_name RotationSynchronizer

# adding new functionality to keep track of rotations in the same direction (to avoid accumulating errors)

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

static var tick := 0.0

static var rotation_axis := Vector3.ZERO

#static var rotation_depth: int
#static var prev_rotation_axis := Vector3.ZERO
#static var block_rotation_axis := Vector3.ZERO

func _init() -> void:
	target = 90.0
	increment = 5
	#rotation_depth = 1

func get_tick_radians() -> float:
	return deg_to_rad(tick)

func get_tick_degrees() -> float:
	return tick

func begin_rotation(axis: Vector3) -> void:
	#if(block_rotation_axis != axis):
	deg_to_target = 0.0
	is_rotating = true
		#prev_rotation_axis = rotation_axis
	rotation_axis = axis
		# added check if initial rotation (Vector3.ZERO)
		#if(prev_rotation_axis == rotation_axis || prev_rotation_axis == Vector3.ZERO):
			#rotation_depth += 1
			#print(rotation_depth)
			#print("add | prev: ", prev_rotation_axis, " | cur: ", rotation_axis)
		#else:
			#rotation_depth -= 1
			#print(rotation_depth)
			#print("sub | prev: ", prev_rotation_axis, " | cur: ", rotation_axis)
		#if(rotation_depth == 2):
			#block_rotation_axis = rotation_axis

#should only ever be called in player.gd's physics process
func step() -> void:
	if is_rotating:
		if deg_to_target != target:
			tick = increment
			deg_to_target += increment
		elif deg_to_target == target:
			tick = 0.0
			is_rotating = false
