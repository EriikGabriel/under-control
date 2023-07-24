extends CanvasLayer

@onready var left_anim := $LEFT as AnimatedSprite2D
@onready var right_anim := $RIGHT as AnimatedSprite2D
@onready var space_anim := $SPACE as AnimatedSprite2D
@onready var enemy_hitbox := $"/root/World-1/Enemy/hitbox" as Area2D
#@onready var platform := $"/root/World-1/Platform" as StaticBody2D

var disabled_keys: Array[String]

# Called when the node enters the scene tree for the first time.
func _ready():
#	platform.disable_keys.connect(on_disable_key)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var event_left = InputMap.action_get_events("move_left")[0]
	var event_right = InputMap.action_get_events("move_right")[0]
	var event_space = InputMap.action_get_events("jump")[0]
	
	var key_left = event_left.as_text().get_slice(" ", 0).to_upper()
	var key_right = event_right.as_text().get_slice(" ", 0).to_upper()
	var key_space = event_space.as_text().get_slice(" ", 0).to_upper()
	
	var left_anim_name = "{state} [{key}]".format({"key": key_left })
	var right_anim_name = "{state} [{key}]".format({"key": key_right })
	var space_anim_name = "{state} [{key}]".format({"key": key_space })
	
	if Input.is_action_pressed("move_left"):
		left_anim.play(left_anim_name.format({"state": "press"}))
	else:
		left_anim.play(left_anim_name.format({"state": "default"}))
#
	if Input.is_action_pressed("move_right"):
		right_anim.play(right_anim_name.format({"state": "press"}))
	else:
		right_anim.play(right_anim_name.format({"state": "default"}))
#
	if Input.is_action_pressed("jump"):
		space_anim.play(space_anim_name.format({"state": "press"}))
	else:
		space_anim.play(space_anim_name.format({"state": "default"}))
#
	if disabled_keys.has("KEY_RIGHT"):
		right_anim.play(right_anim_name.format({"state": "press"}))
	if disabled_keys.has("KEY_SPACE"):
		space_anim.play(space_anim_name.format({"state": "press"}))

func on_disable_key(keys):
	disabled_keys = keys
