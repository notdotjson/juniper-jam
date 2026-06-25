class_name RotationSynchronizer

static var is_rotating := false

static var target: float

static var increment: float
	
static var deg_to_target := 0.0

static var direction: Vector3

func _init() -> void:
	target = 90.0
	increment = 5.0

func get_quaternion(is_player: bool = false) -> Quaternion:
	if is_player:
		return Quaternion.from_euler(-direction * deg_to_rad(increment))
	return Quaternion.from_euler(direction * deg_to_rad(increment))

func begin_rotation(rotation_direction: Vector3) -> void:
	deg_to_target = 5.0
	is_rotating = true
	direction = rotation_direction
	#print("prev_target: ", prev_target, " | target: ", target, " | deg_to_target: ", deg_to_target)

#should only ever be called in player.gd's physics process
func step() -> void:
	print(deg_to_target)
	if is_rotating:
		if deg_to_target != target:
			deg_to_target += increment
		elif deg_to_target == target:
			is_rotating = false
