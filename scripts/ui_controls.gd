extends CanvasLayer

@onready var A_anim := $A as AnimatedSprite2D
@onready var D_anim := $D as AnimatedSprite2D
@onready var SPACE_anim := $SPACE as AnimatedSprite2D
@onready var enemy_hitbox := $"/root/World-1/Enemy/hitbox" as Area2D
@onready var platform := $"/root/World-1/Platform" as StaticBody2D

var disabled_key

# Called when the node enters the scene tree for the first time.
func _ready():
	platform.disable_key.connect(on_disable_key)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_pressed("move_left"):
		A_anim.play("press")
	else:
		A_anim.play("default")
	
	if Input.is_action_pressed("move_right"):
		D_anim.play("press")
	else:
		D_anim.play("default")
	
	if Input.is_action_pressed("jump"):
		SPACE_anim.play("press")
	else:
		SPACE_anim.play("default")
		
	if disabled_key == "RIGHT":
		D_anim.play("press")

func on_disable_key(key):
	disabled_key = key
