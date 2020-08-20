extends Node
class_name StateMachine

var _previousState = null
var _state = null
var _parent 
var _initial_state


func _step(delta):
	if _state != null:
		_state._step(delta)
	_handle_transitions()

#Checks if changing active states is necessary
#And calls _change_state in class State Machine if it is 
func _handle_transitions():
	var new : State
	new = _check_for_needed_transition(_state)		
	if new != null: _change_state(new)

#Iterates through states checks and if the criteria to switch to another
#State is met, returns that state. Else returns null 
func _check_for_needed_transition(state: State) -> State:
	var s : State
	for n in range(state.get_checks().size()):
		s = call(state.get_checks()[n])
		if s != null:
			return s
	return null


func _change_state(newState):
	if _state != null:
		_previousState = _state
		_previousState._exit()
	if newState != null:
		_state = newState
		_state._enter() 
