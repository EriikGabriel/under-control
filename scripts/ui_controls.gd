extends CanvasLayer

@onready var A_anim := $A as AnimatedSprite2D
@onready var D_anim := $D as AnimatedSprite2D
@onready var SPACE_anim := $SPACE as AnimatedSprite2D
@onready var enemy_hitbox := $"/root/World-1/Enemy/hitbox" as Area2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_pressed("move_left"):
		if enemy_hitbox.inverted_control:
			D_anim.play("press")
		else:
			A_anim.play("press")
	else:
		if enemy_hitbox.inverted_control:
			D_anim.play("default")
		else:
			A_anim.play("default")
	
	if Input.is_action_pressed("move_right"):
		if enemy_hitbox.inverted_control:
			A_anim.play("press")
		else:
			D_anim.play("press")
	else:
		if enemy_hitbox.inverted_control:
			A_anim.play("default")
		else:
			D_anim.play("default")
	
	if Input.is_action_pressed("jump"):
		SPACE_anim.play("press")
	else:
		SPACE_anim.play("default")
		
		
