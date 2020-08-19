extends State
class_name IdleClimb

func _enter():
	print("idle climb")
	_machine.adjust_animation(0.0)
	
	
func _step(delta):
	pass
	
func _exit():
	_machine.adjust_animation(1.0)
