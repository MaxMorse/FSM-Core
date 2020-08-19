extends State

class_name StateRunning

func _enter():
	_machine.change_animation("Running")

func _step(delta):
	_machine.horizontal_movement(delta)
	_machine.apply_gravity(delta)
	
func _exit():
	pass
