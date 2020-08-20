extends State

class_name StateRunning

func _step(delta):
	_machine.horizontal_movement(delta)
	_machine.apply_gravity(delta)
