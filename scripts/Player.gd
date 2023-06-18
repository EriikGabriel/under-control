extends CharacterBody2D

const SPEED = 100.0
const JUMP_FORCE = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var is_jumping = false

@onready var animation := $anim as AnimatedSprite2D
@onready var remote_tranform := $remote as RemoteTransform2D

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_FORCE
		is_jumping = true
	elif is_on_floor():
		is_jumping = false

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * SPEED
		animation.scale.x = direction
		if !is_jumping:
			animation.play("running")
	elif is_jumping:
		animation.play("jumping")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		animation.play("idle")

	move_and_slide()


func _on_hurtbox_body_entered(body: Node2D):
	if body.is_in_group("enemies"):
		print("Player: Hurt!")
		
func follow_camera(camera):
	var camera_path = camera.get_path()
	remote_tranform.remote_path = camera_path
