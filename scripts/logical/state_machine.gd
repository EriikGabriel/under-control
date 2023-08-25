extends Node
class_name StateMachine

@export var actor: CharacterBody2D
@export var anim: AnimatedSprite2D
@export var initial_state: State

var current_state: State
var states: Dictionary

func _ready() -> void:
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			child.Enter()

func _process(_delta: float) -> void:
	current_state = initial_state
	
	for state_name in states:
		var condition = (states[state_name] as State).Condition()
		if(condition):
			current_state = states[state_name]
	
	if anim.animation != current_state.name:
		anim.play(current_state.name)
