extends Node3D

var rotsync: RotationSynchronizer

func _ready() -> void:
	rotsync = RotationSynchronizer.new()

func _physics_process(_delta: float) -> void:
	if rotsync.is_rotating:
		quaternion *= rotsync.get_quaternion()
		pass
		#quaternion = quaternion.slerp(rotsync.get_target_quaternion(), _delta * 10.0)
		#if quaternion.angle_to(rotsync.get_target_quaternion()) < 0.001:
			#quaternion = rotsync.get_target_quaternion()
		#quaternion = quaternion.slerp(rotsync.get_target_quaternion(), _delta * 5.0)
