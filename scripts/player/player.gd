extends CharacterBody2D

class_name Player

const SPEED = 100.0
const JUMP_FORCE = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

# State animations flag's
var is_jumping = false
var is_hurt = false
var is_death = false
var is_attacking = false

var knockback_vector = Vector2.ZERO
var direction

# Control flag's
var control_inverted = false
var keys_modified = false
var disabled_keys: Array[String]

@export var life := 3

@onready var animation := $anim as AnimatedSprite2D
@onready var remote_tranform := $remote as RemoteTransform2D
@onready var raycast_right := $raycast_right as RayCast2D
@onready var raycast_left := $raycast_left as RayCast2D 
@onready var colision := $collision as CollisionShape2D
@onready var hurtbox := $hurtbox as Area2D

func _ready():
	# Conecta os sinais para receber notificações de alteração
	SignalBus.on_controls_changed.connect(_on_signal_controls_changed)
	SignalBus.on_keys_changed.connect(_on_signal_keys_changed)
	SignalBus.on_health_changed.connect(_on_signal_health_changed)
#	platform.disable_keys.connect(on_disable_keys)

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
		
	# Handle Jump.
	var action_jump = "jump_mod" if keys_modified else "jump"
	
	if Input.is_action_just_pressed(action_jump) && !disabled_keys.has("KEY_SPACE") && is_on_floor():
		velocity.y = JUMP_FORCE
		is_jumping = true
	elif is_on_floor():
		is_jumping = false
		
	if Input.is_action_just_pressed("attack"):
		is_attacking = true
		await get_tree().create_timer(1.5).timeout
		is_attacking = false
	
	if keys_modified:
		direction = Input.get_axis("move_left_mod", "move_right_mod")
	else: 
		direction = Input.get_axis("move_left", "move_right")

	if disabled_keys.has("KEY_RIGHT") && direction > 0: direction = 0
	
	if control_inverted:
		_invert_control()

	if direction != 0 && !is_death:
		velocity.x = direction * SPEED
		animation.scale.x = direction
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	if knockback_vector != Vector2.ZERO:
		velocity = knockback_vector
	
	_set_state()
	if !is_death: move_and_slide()
	
	for platforms in get_slide_collision_count():
		var collision = get_slide_collision(platforms)
		if collision.get_collider().has_method("has_collided_with"):
			collision.get_collider().has_collided_with(collision, self)

func follow_camera(camera):
	var camera_path = camera.get_path()
	remote_tranform.remote_path = camera_path

func take_damage(knockback_force := Vector2.ZERO, duration := 0.25):
	if knockback_force != Vector2.ZERO:
		var knockback_tween := get_tree().create_tween()
		
		knockback_vector = knockback_force 
		knockback_tween.parallel().tween_property(self, "knockback_vector", Vector2.ZERO, duration)
		animation.modulate = Color(1, 0, 0, 1)
		knockback_tween.parallel().tween_property(animation, "modulate", Color(1,1,1,1), duration)
	
	is_hurt = true
	await get_tree().create_timer(.3).timeout
	is_hurt = false

func _set_state():
	var state = "idle"
	
	if !is_on_floor():
		state = "jumping"
	elif direction != 0:
		state = "running"

	if is_attacking:
		state = "attack"

	if is_hurt:
		state = "hurt"

	if is_death:
		state = "death"

	if animation.animation != state:
		animation.play(state)

func on_disable_keys(keys: Array[String]):
	disabled_keys = keys

# Controls changes
func _on_signal_controls_changed(changes: Array[SignalBus.ControlChange]):
	control_inverted = changes.has(SignalBus.ControlChange.INVERT)

# Keys changes	
func _on_signal_keys_changed(changes: Array[SignalBus.KeyChange]):
	keys_modified = !changes.has(SignalBus.KeyChange.NORMAL)

# Health changes
func _on_signal_health_changed(node: Node, amount_changed: int, current_health: int):
	if(node is Player):
		if(amount_changed < 0): # if take damage
			if raycast_right.is_colliding():
				take_damage(Vector2(-200, -200))
			elif raycast_left.is_colliding():
				take_damage(Vector2(200, -200))

		if(current_health == 0):
			is_death = true
			set_collision_layer_value(1, false) # Player layer
			set_collision_mask_value(3, false) # Enimy mask

func _invert_control():
	direction *= -1
