extends CharacterBody2D

const SPEED = 700.0
const JUMP_VELOCITY = -400.0

var direction := -1

@onready var animation := $anim as AnimatedSprite2D
@onready var raycast := $raycast as RayCast2D

signal enemy_attack

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	if raycast.is_colliding():
		animation.play("attacking");
		velocity.x = 0
	else:
		velocity.x = direction * SPEED * delta
		animation.play("running")

	move_and_slide()

func _on_anim_animation_finished():
	emit_signal("enemy_attack", self)
