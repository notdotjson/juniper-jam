extends Node3D

var rotation_sync: RotationSynchronizer

func _ready() -> void:
	rotation_sync = RotationSynchronizer.new()

func _physics_process(_delta: float) -> void:
	if rotation_sync.is_rotating:
		global_rotate(rotation_sync.get_rotation_axis(), rotation_sync.get_degrees_radians())
