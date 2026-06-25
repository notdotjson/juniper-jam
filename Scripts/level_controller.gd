extends Node3D

var _target_angle = 90.0
var _deg_to_target = 90.0
var _angle_increm = 2.5
var _is_rotating = false

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	if _is_rotating:
		if _deg_to_target != _target_angle:
			global_rotate(Vector3.FORWARD, deg_to_rad(_angle_increm))
			_deg_to_target += _angle_increm
		elif _deg_to_target == _target_angle:
			_is_rotating = false

		
func _input(event: InputEvent) -> void:
		if !_is_rotating:
			if event.is_action_pressed("rotate_map_forward"):
				_deg_to_target = 0.0
				_is_rotating = true
