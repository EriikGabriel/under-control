extends CharacterBody2D

const SPEED = 700.0
const JUMP_VELOCITY = -400.0

# State animations flag's
var is_running = false
var is_attacking = false

var direction := -1

@onready var animation := $anim as AnimatedSprite2D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	pass

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	velocity.x = direction * SPEED * delta

	_set_state()
	move_and_slide()
	

func _on_attack_area_body_entered(body: Node2D) -> void:
	if body is Player:
		is_attacking = true
		await get_tree().create_timer(0.6).timeout
		is_attacking = false

		if(body.raycast_left.is_colliding() || body.raycast_right.is_colliding()):
			for child in body.get_children():
				if child is Damageable:
					child.hit(1)

func _set_state():
	var state = "walk"

	if is_attacking:
		state = "attack"

	if animation.animation != state:
		animation.play(state)

