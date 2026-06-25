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

static var tick := 0.0

static var direction: Vector3

func _init() -> void:
	target = 90.0
	increment = 5

func get_tick_radians() -> float:
	#print(tick)
	return deg_to_rad(tick)

func get_tick_degrees() -> float:
	return tick

func begin_rotation(rotation_direction: Vector3) -> void:
	deg_to_target = 0.0
	is_rotating = true
	direction = rotation_direction

#should only ever be called in player.gd's physics process
func step() -> void:
	if is_rotating:
		if deg_to_target != target:
			tick = increment
			#print("Stepping! from ", deg_to_target, " degrees, to ", target, " degrees.")
			deg_to_target += increment
		elif deg_to_target == target:
			tick = 0.0
			is_rotating = false
