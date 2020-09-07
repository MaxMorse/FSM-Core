extends State

class_name StateClimbing

func _enter():
	#_machine.change_animation("Climbing")
	_machine.halt_x_movement()
	_machine.set_parent_current_ladder()

func _step(delta):
	_machine.climb(delta)
