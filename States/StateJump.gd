extends State
class_name StateJumping


func _enter():
	_machine.jump()

func _step(delta):
	_machine.horizontal_movement(delta)
	_machine.apply_gravity(delta)
