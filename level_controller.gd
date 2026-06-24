extends Node3D

var _target_angle = 90.0
var _deg_to_target = 90.0
var _angle_increm = 2.5
var _lockout = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _physics_process(delta: float) -> void:
	if _lockout:
		if _deg_to_target != _target_angle:
			global_rotate(Vector3.FORWARD, deg_to_rad(_angle_increm))
			_deg_to_target += _angle_increm
			print("rotating!! degrees to target: ", _deg_to_target)
		elif _deg_to_target == _target_angle:
			_lockout = false
			print("rotation finished, lockout cleared!")

		
func _input(event: InputEvent) -> void:
		if !_lockout:
			if event.is_action_pressed("rotate_map_forward"):
				_deg_to_target = 0.0
				_lockout = true
				print("action detected, locked out of rotation!")
