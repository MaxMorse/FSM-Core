extends StateMachine
class_name PlayerStateMachine

var states : Array
#state vars
var idle
var falling
var jumping
var running
#input vars
var jump_button_just_pressed
var jump_button_just_released
var x_input
var up_button_pressed
var down_button_pressed
var y_input	

#Constructor
#instantiates all states and sets initial state 
func _init(Parent):
	_parent = Parent
	var runningChecks = ['should_jump','should_fall','should_idle']
	var idleChecks = ['should_jump','should_run']
	var fallingChecks =['should_idle', 'should_run']
	var jumpingChecks =['should_fall']
	var climbingChecks = ['check_ladder_to_falling']
	
	idle = init_state(StateIdle, idleChecks, "Idle")
	falling = init_state(StateFalling, fallingChecks, "Falling")
	jumping = init_state(StateJumping, jumpingChecks, "Jumping")
	running = init_state(StateRunning, runningChecks, "Running")
	
	
	
	_change_state(idle)		

#Takes the name of a class that inherits from state
#And returns an instance of that state
#Optional string state_name is for testing purposes 
#And can be displayed if State Label node on parent exists  
func init_state(state_class, state_checks, state_name):
	var s = state_class.new()
	s._init_state(self, state_checks, state_name)
	return s

#Checks if changing active states is necessary
#And calls _change_state in class State Machine if it is 
func _handle_transitions():
	var new : State
	new = check_for_needed_transition(_state)		
	if new != null: _change_state(new)

func _step(delta):
	get_input()	
	if _state != null:
		_state._step(delta)
	_handle_transitions()


#gets relevent player input from Input class
func get_input():
	x_input = Input.get_action_strength("Right") - Input.get_action_strength("Left")
	jump_button_just_pressed = Input.is_action_just_pressed("Jump")
	jump_button_just_released = Input.is_action_just_released("Jump")
	up_button_pressed = Input.is_action_pressed("Up")
	down_button_pressed = Input.is_action_pressed("Down")
	y_input = Input.get_action_strength("Down") - Input.get_action_strength("Up")


###
## Player Movement 
###

#Multiplies a number by player's jumpforce and applies 
#That value to player's vertical motion at start of jump
func jump(multiplier = 1):
	_parent.motion.y = -_parent.jump_force * multiplier

#Slows the player's horizontal movement to a halt smoothly
func slow_down(delta):
	_parent.motion.x = lerp(_parent.motion.x, 0, _parent.friction * delta)
			
#Applies horizontal input smoothly to player's horizontal motion
#Caps horizontal motion at player's max speed
func horizontal_movement(delta):
	if x_input < 0:
		_parent.sprite.flip_h = true
	elif x_input > 0:
		_parent.sprite.flip_h = false
	_parent.motion.x += x_input * _parent.acceleration * delta * _parent.TARGET_FPS
	_parent.motion.x = clamp(_parent.motion.x, -_parent.max_speed, _parent.max_speed)

#Applies gravity to player's veritical motion	
func apply_gravity(delta):
	_parent.motion.y += _parent.gravity * delta * _parent.TARGET_FPS

func adjust_animation(speed_scale : float):
	_parent.sprite.speed_scale = speed_scale
	
func change_animation(animation: String):
	if (_parent.sprite is AnimatedSprite):
		_parent.sprite.play(animation)
#Multiplies vertical input by climb speed  
#And applies it to player's vertical motion
#Used for climbing ladders 
func climb(delta):
	_parent.motion.y =y_input * _parent.climb_speed * delta * _parent.TARGET_FPS
	#_parent.motion.y = clamp(_parent.motion.y, -_parent.max_speed, _parent.max_speed)

#halts player's horizontal motion immediately
#Called at the start of climb state to ensure 
#Player doesn't drift horizonally away from ladder	
func halt_x_movement():
	_parent.motion.x = 0

func should_fall() -> State: 
	if _parent.motion.y > 0 && !_parent.is_on_floor():
		return falling
	else:
		return null

func should_jump() -> State:
	if jump_button_just_pressed:
		return jumping
	else:
		return null

func should_idle() -> State:
	if _parent.is_on_floor() && x_input == 0:
		return idle
	else:
		return null
func should_run() -> State:
	if _parent.is_on_floor() && x_input != 0:
		return running
	else:
		return null 
		
func check_for_needed_transition(state: State) -> State:
	var s : State
	for n in range(state.get_checks().size()):
		s = call(state.get_checks()[n])
		if s != null:
			return s
		
	return null
