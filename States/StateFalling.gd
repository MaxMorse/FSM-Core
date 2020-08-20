extends State

class_name StateFalling
	
func _step(delta):
	_machine.horizontal_movement(delta)	
	_machine.apply_gravity(delta)
	
