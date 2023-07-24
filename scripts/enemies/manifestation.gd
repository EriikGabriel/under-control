extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var direction = -1

var default_keys_events: Dictionary = {}

@export var change_keys: Array[StringName] = []
@export var potential_keys: Array[Key] = []

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	for action_name in change_keys:
		default_keys_events[action_name] = InputMap.action_get_events(action_name)[0]

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	if direction:
		velocity.x = direction * SPEED * delta
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()


func _on_area_body_entered(body):
	if body.name == "Player": _random_control()

func _on_area_body_exited(body):
	if body.name == "Player": _reset_control()

func _random_control():
	var keys_quantity = change_keys.size()
	
	if potential_keys.size() < keys_quantity: return
	
	for key_name in change_keys:
		InputMap.action_erase_events(key_name)
	
	var new_controller_keys: Array[Key] = []
	
	while new_controller_keys.size() < keys_quantity:
		var key = potential_keys.pick_random()
		
		if !new_controller_keys.has(key): 
			new_controller_keys.append(key)
	
	for i in keys_quantity:
		var event = InputEventKey.new()
		event.keycode = new_controller_keys[i]
		InputMap.action_add_event(change_keys[i], event)

func _reset_control():
	for action in default_keys_events:
		InputMap.action_erase_events(action)
		InputMap.action_add_event(action, default_keys_events[action])
	
