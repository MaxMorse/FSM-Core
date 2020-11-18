extends StateMachine
class_name PlayerStateMachine
var states 
#state vars
var idle
var falling
var jumping 
var running 
var climbing
var climbing_up
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
	var idleChecks = ['should_jump','should_run', 'should_climb']
	var fallingChecks =['should_idle', 'should_run']
	var jumpingChecks =['should_fall']
	var climbingChecks = ['check_ladder_to_falling', 'should_step_down_off_ladder', 'should_step_up_off_ladder']
	var climbing_upChecks = ['check_done_climbing_up']
	idle = init_state(StateIdle, idleChecks, "Idle")
	falling = init_state(StateFalling, fallingChecks, "Falling")
	jumping = init_state(StateJumping, jumpingChecks, "Jumping")
	running = init_state(StateRunning, runningChecks, "Running")
	climbing = init_state(StateClimbing, climbingChecks, "Climbing")
	climbing_up = init_state(StateClimbingUp, climbing_upChecks, "Climbing Up")
	_change_state(idle)
#This is a test
#Takes the name of a class that inherits from state
#And returns an instance of that state
#Optional string state_name is for testing purposes 
#And can be displayed if State Label node on parent exists  
func init_state(state_class, state_checks, state_name):
	var s = state_class.new()
	s._init_state(self, state_checks, state_name)
	return s

func _step(delta):
	get_input()	
	._step(delta)


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
func set_one_way_collisions(active: bool):
	_parent.set_collision_mask_bit(2, active)

func set_parent_current_ladder():
	if y_input < 0:
		_parent.set_current_ladder(_parent.ladder_above)
	else:
		_parent.set_current_ladder(_parent.ladder_below)


#Multiplies a number by player's jumpforce and applies 
#That value to player's vertical motion at start of jump
func jump(multiplier: float = 1):
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
	if( y_input > 0 && _parent.ladder_below):
		_parent.set_collision_mask_bit(2, false) 
	if (y_input < 0 && _parent.position.y <= _parent.current_ladder.top_y):
		_parent.motion.y = 0
	else:
		_parent.motion.y =y_input * _parent.climb_speed * delta * _parent.TARGET_FPS

func climb_up_off(delta):
	_parent.motion.y = -1 * _parent.climb_speed * delta * _parent.TARGET_FPS

	
func halt_x_movement():
	_parent.motion.x = 0

func should_fall() -> State: 
	if _parent.motion.y > 0 && !_parent.is_on_floor():
		return falling
	else:
		return null

func should_climb() -> State:
	if up_button_pressed && _parent.ladder_above:
		return climbing
	elif down_button_pressed && _parent.ladder_below:
		return climbing
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
	
func check_ladder_to_falling() -> State:
	if jump_button_just_pressed: 
		return falling
	else:
		 return null 

func check_for_needed_transition(state: State) -> State:
	var s : State
	for n in range(state.get_checks().size()):
		s = call(state.get_checks()[n])
		if s != null:
			return s
		
	return null

func should_step_up_off_ladder() -> State:
	var c_ladder = _parent.current_ladder
	if y_input < 0 && _parent.position.y < c_ladder.top_y && c_ladder.has_top_exit :
		return climbing_up 
	return null



func should_step_down_off_ladder() -> State:
	#print("in should step down off ladder")
	if y_input > 0:
		
		if _parent.current_ladder != null:
			var dif = _parent.current_ladder.base_y - _parent.position.y
			if dif < _parent.height * 0.5 + 1: return idle 
	return null

func check_done_climbing_up() -> State:
	var c_ladder = _parent.current_ladder
	if _parent.position.y < (c_ladder.top_y - _parent.height * 0.5):
		return idle
	return null
