extends Control

const SPEED = 20.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var direction = 1

@onready var player: CharacterBody2D = $Player
@onready var anim: AnimatedSprite2D = $Player/anim

func _physics_process(delta: float) -> void:
	if(!player.is_on_floor()):
		player.velocity.y += gravity * delta
	
	if direction != 0:
		anim.play("run")
		player.velocity.x = direction * SPEED
		anim.scale.x = direction
	else:
		player.velocity.x = move_toward(player.velocity.x, 0, SPEED)
	
	player.move_and_slide()

func _on_limit_left_body_entered(_body: Node2D):
	direction = 1

func _on_limit_right_body_entered(_body: Node2D):
	direction = -1
