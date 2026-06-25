class_name RotationHelper

var is_rotating = false
var target_angle = 90.0
var deg_to_target = 0
var angle_increm = 2.5

func set_rotation_target(degrees: float) -> bool:
	if is_rotating:
		return false
	target_angle = degrees
	return true

func set_angle_increment(degrees: float) -> bool:
	if is_rotating:
		return false
	angle_increm = degrees
	return true

func check_if_rotating() -> bool:
	return is_rotating

func do_rotation_tick() -> float:
	if is_rotating:
		if deg_to_target != target_angle:
			deg_to_target += angle_increm
			return deg_to_rad(angle_increm)
		elif deg_to_target == target_angle:
			is_rotating = false
			return 0.0
	return 0.0
