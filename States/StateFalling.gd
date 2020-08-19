extends State

class_name StateFalling
	
func _enter():
	_machine.change_animation("Falling")
	
func _step(delta):
	_machine.horizontal_movement(delta)	
	_machine.apply_gravity(delta)
	
