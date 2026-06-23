extends Node3D

var _target = basis
var _lockout = false
var _rotation_timer = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if basis != _target:
		basis = lerp(basis, _target, "0.05")
		_rotation_timer += delta
		print("rotating!! t: ", _rotation_timer)
	if _rotation_timer >= 1.8:
		basis = _target
		_rotation_timer = 0.0
		_lockout = false
		print("rotation finished, lockout cleared!")

		
func _input(event: InputEvent) -> void:
		if !_lockout:
			if event.is_action_pressed("rotate_map_forward"):
				_target = _target.rotated(Vector3.FORWARD, deg_to_rad(90))
				_lockout = true
				print("action detected, locked out of rotation!")
