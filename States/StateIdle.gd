extends State
class_name StateIdle

func _step(delta):
	_machine.slow_down(delta)
	_machine.apply_gravity(delta)
