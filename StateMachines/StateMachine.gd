extends Node
class_name StateMachine

var _previousState = null
var _state = null
var _parent 
var _initial_state


func _change_state(newState):
	if _state != null:
		_previousState = _state
		_previousState._exit()
	if newState != null:
		_state = newState
		_state._enter() 
