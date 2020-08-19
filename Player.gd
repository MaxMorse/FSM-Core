extends KinematicBody2D

const TARGET_FPS = 60
export(int) var acceleration = 16
export(int) var max_speed = 128
export(int) var friction = 20
export(int) var air_resistance = 2
export(int) var gravity = 8
export(int) var jump_force = 280

var motion = Vector2.ZERO

onready var sprite = $Sprite
onready var stateLabel = $StateLabel

var stateMachine

func _ready():
	stateMachine = PlayerStateMachine.new(self)

func _physics_process(delta):
	stateMachine._step(delta)
	motion = move_and_slide(motion, Vector2.UP)
	stateLabel.text = stateMachine._state._state_name
