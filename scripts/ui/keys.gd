extends Control

@onready var left_anim := $LEFT as AnimatedSprite2D
@onready var right_anim := $RIGHT as AnimatedSprite2D
@onready var space_anim := $SPACE as AnimatedSprite2D

#@onready var platform := $"/root/World-1/Platform" as StaticBody2D

# Keys flags
var keys_disabled: Array[SignalBus.DisableKeys] = []
var keys_modified = false

func _ready():
	SignalBus.on_keys_changed.connect(_on_signal_keys_changed)

func _process(_delta):
	var action_left = "move_left" if !keys_modified else "move_left_mod"
	var action_right = "move_right" if !keys_modified else "move_right_mod"
	var action_space = "jump" if !keys_modified else "jump_mod"
	
	var event_left =  InputMap.action_get_events(action_left)[0]
	var event_right = InputMap.action_get_events(action_right)[0]
	var event_space = InputMap.action_get_events(action_space)[0]
	
	var key_left = event_left.as_text().get_slice(" ", 0).to_upper()
	var key_right = event_right.as_text().get_slice(" ", 0).to_upper()
	var key_space = event_space.as_text().get_slice(" ", 0).to_upper()
	
	var left_anim_name = "{state} [{key}]".format({"key": key_left })
	var right_anim_name = "{state} [{key}]".format({"key": key_right })
	var space_anim_name = "{state} [{key}]".format({"key": key_space })
	
	if Input.is_action_pressed(action_left):
		left_anim.play(left_anim_name.format({"state": "press"}))
	else:
		left_anim.play(left_anim_name.format({"state": "default"}))

	if Input.is_action_pressed(action_right):
		right_anim.play(right_anim_name.format({"state": "press"}))
	else:
		right_anim.play(right_anim_name.format({"state": "default"}))

	if Input.is_action_pressed(action_space):
		space_anim.play(space_anim_name.format({"state": "press"}))
	else:
		space_anim.play(space_anim_name.format({"state": "default"}))

	if keys_disabled.has(SignalBus.DisableKeys.KEY_LEFT):
		left_anim.play(left_anim_name.format({"state": "press"}))
	if keys_disabled.has(SignalBus.DisableKeys.KEY_RIGHT):
		right_anim.play(right_anim_name.format({"state": "press"}))
	if keys_disabled.has(SignalBus.DisableKeys.KEY_SPACE):
		space_anim.play(space_anim_name.format({"state": "press"}))

func _on_signal_keys_changed(changes: Array[SignalBus.KeyChange], value):
	keys_modified = changes.has(SignalBus.KeyChange.RANDOM)
	
	if changes.has(SignalBus.KeyChange.DISABLE): keys_disabled = value
	else: keys_disabled = []

func on_disable_key(keys):
	keys_disabled = keys

