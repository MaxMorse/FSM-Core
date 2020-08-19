extends State
class_name StateIdle

func _enter():
	_machine.change_animation("Idle")
	

func _step(delta):
	_machine.slow_down(delta)
	_machine.apply_gravity(delta)
