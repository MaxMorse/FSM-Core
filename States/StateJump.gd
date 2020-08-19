extends State
class_name StateJumping

#Called by machine when state is made current state
func _enter():
	_machine.jump()
	_machine.change_animation("Jumping")
#Called by machine on each physics update
#Calls machine's movement functions relevent to state  
func _step(delta):
	_machine.horizontal_movement(delta)
	_machine.apply_gravity(delta)
