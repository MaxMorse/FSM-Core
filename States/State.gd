extends Node
class_name State

var _state_name = ""
var _machine
var _checks setget, get_checks

func get_checks():
	return _checks

#Constructor
func _init_state(machine, checks, state_name = ""):
	_machine = machine
	_checks = checks
	_state_name = state_name

#Called by machine when state is made current state 
#Player sprite animations can easily be changed here
func _enter():
	pass

#Called by machine on each physics update
func _step(delta):
	pass

#Called by machine when state is swapped for a new one. 
#Use if end of state logic is needed	
func _exit():
	pass

	
