extends State

class_name StateClimbing

func _enter():
	_machine.change_animation("Climbing")
	_machine.halt_x_movement()

func _step(delta):
	_machine.climb(delta)
