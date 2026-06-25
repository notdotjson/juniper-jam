extends Node3D

var rotation_sync: RotationSynchronizer

func _ready() -> void:
	rotation_sync = RotationSynchronizer.new()

func _physics_process(delta: float) -> void:
	if rotation_sync.is_rotating:
		global_rotate(rotation_sync.direction, rotation_sync.get_tick_radians())