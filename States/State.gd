extends Node
class_name State

var _state_name = ""
var _machine : StateMachine
var _checks setget, get_checks

func get_checks():
	return _checks

#Constructor
func _init_state(machine : StateMachine, checks: Array):
	_machine = machine
	_checks = checks



#Called by machine when state is made current state 
func _enter():
	pass

#Called by machine on each physics update
func _step(delta):
	pass

	
func _exit():
	pass

	
