extends State
class_name StateClimbingUp

func _step(delta):
	_machine.climb_up_off(delta)
	
func _exit():
	_machine.set_one_way_collisions(true)
