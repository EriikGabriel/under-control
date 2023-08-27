extends CharacterBody2D
class_name Player

const SPEED = 100.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

# State animations flag's
var is_hurt = false
var is_death = false
var is_attacking = false
var is_jump = false

# Knockback vector
var knockback = Vector2.ZERO

# Player control variables
var direction: float
var jump_force: float
var jump_action: String
var moves_action: Dictionary

# Control flag's
var control_inverted = false
var keys_modified = false
var keys_disabled: Array[SignalBus.DisableKeys] = []

@onready var animation: AnimatedSprite2D = $anim
@onready var remote_tranform: RemoteTransform2D = $remote
@onready var raycast_left: RayCast2D = $raycast_left
@onready var raycast_right: RayCast2D = $raycast_right
@onready var hurtbox: Area2D = $hurtbox
@onready var hitbox: Area2D = $hitbox

func _ready():
	# Connect signals to receive change notifications
	SignalBus.on_controls_changed.connect(_on_signal_controls_changed)
	SignalBus.on_keys_changed.connect(_on_signal_keys_changed)
	SignalBus.on_health_changed.connect(_on_signal_health_changed)

func _physics_process(delta):
	if(!is_on_floor()):
		velocity.y += gravity * delta
	elif(is_jump):
		is_jump = false

	jump_action = "jump"
	moves_action = {"left": "move_left", "right": "move_right"}
	jump_force = -400
	
	if(keys_modified): _random_control()

	# Direction Handler
	direction = Input.get_axis(moves_action["left"], moves_action["right"])
	
	if(keys_disabled): _disable_keys()
	if(control_inverted): _invert_control()

	# Move honzontal
	if direction != 0:
		velocity.x = direction * SPEED
		animation.scale.x = direction
		hitbox.scale.x = direction
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	# Jump Handler
	if Input.is_action_just_pressed(jump_action) && is_on_floor():
		is_jump = true
		velocity.y = jump_force

	# Attack Handler
	if Input.is_action_just_pressed("attack"): is_attacking = true
	
	# Platforms Colliders
	for platforms in get_slide_collision_count():
		var collision = get_slide_collision(platforms)
		
		if(!collision.get_collider()): continue
		
		if collision.get_collider().has_method("has_collided_with"):
			collision.get_collider().has_collided_with(collision, self)

	# Knockback Handler
	if knockback != Vector2.ZERO:
		velocity = knockback

	if !is_death: move_and_slide()

# Camera follows player
func follow_camera(camera):
	var camera_path = camera.get_path()
	remote_tranform.remote_path = camera_path

# When player attacks an enemy or spell
func _on_hitbox_body_entered(body: Node2D) -> void:
	if(body is SpellBullet):
		body.queue_free()
		return
	
	for child in body.get_children():
			if child is Damageable: 
				child.hit(1, Vector2(200 * hitbox.scale.x, -200))

# Controls changes
func _on_signal_controls_changed(changes: Array[SignalBus.ControlChange], _value):
	control_inverted = changes.has(SignalBus.ControlChange.INVERT)

# Keys changes	
func _on_signal_keys_changed(changes: Array[SignalBus.KeyChange], value):
	keys_modified = changes.has(SignalBus.KeyChange.RANDOM)
	
	if changes.has(SignalBus.KeyChange.DISABLE): keys_disabled = value
	else: keys_disabled = []

# Health changes
func _on_signal_health_changed(node: Node, _amount_changed: int, current_health: int):
	if(node is Player && current_health == 0):
		set_collision_layer_value(1, false) # Player layer
		set_collision_mask_value(3, false) # Enimy mask

func _on_anim_frame_changed():
	if(animation.animation == "attack" && animation.frame == 4):
		hitbox.monitoring = true

func _on_anim_animation_finished():
	match (animation.animation):
		"attack":
			is_attacking = false
			hitbox.monitoring = false
		"hurt":
			is_hurt = false

# Spells
func _invert_control():
	direction *= -1
	
func _random_control():
	jump_action = "jump_mod"
	moves_action = {"left": "move_left_mod", "right": "move_right_mod"}

func _disable_keys():
	if(keys_disabled.has(SignalBus.DisableKeys.KEY_LEFT) && direction < 0): 
		direction = 0

	if(keys_disabled.has(SignalBus.DisableKeys.KEY_RIGHT) && direction > 0):
		direction = 0

	if(keys_disabled.has(SignalBus.DisableKeys.KEY_SPACE) && Input.is_action_just_pressed(jump_action)): 
		jump_force = 0





