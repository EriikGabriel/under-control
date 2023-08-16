extends CharacterBody2D

class_name Player

const SPEED = 100.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

# State animations flag's
var is_hurt = false
var is_death = false
var is_attacking = false

var knockback_vector = Vector2.ZERO

# Player control variables
var direction: float
var jump_force: float
var jump_action: String
var moves_action: Dictionary

# Control flag's
var control_inverted = false
var keys_modified = false
var keys_disabled: Array[SignalBus.DisableKeys] = []

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

func _physics_process(delta):
	if(!is_on_floor()): velocity.y += gravity * delta

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
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	# Jump Handler
	if Input.is_action_just_pressed(jump_action) && is_on_floor():
		velocity.y = jump_force

	# Attack Handler
	if Input.is_action_just_pressed("attack"):
		is_attacking = true
		await get_tree().create_timer(1.5).timeout
		is_attacking = false

	# Platforms Colliders
	for platforms in get_slide_collision_count():
		var collision = get_slide_collision(platforms)
		if collision.get_collider().has_method("has_collided_with"):
			collision.get_collider().has_collided_with(collision, self)
	
	# Knockback Handler
	if knockback_vector != Vector2.ZERO:
		velocity = knockback_vector

	if !is_death: move_and_slide()

func follow_camera(camera):
	var camera_path = camera.get_path()
	remote_tranform.remote_path = camera_path

func take_damage(knockback_force := Vector2.ZERO, duration := 0.25):
	if(knockback_force != Vector2.ZERO):
		var knockback_tween := get_tree().create_tween()
		
		knockback_vector = knockback_force 
		knockback_tween.parallel().tween_property(self, "knockback_vector", Vector2.ZERO, duration)
		animation.modulate = Color(1, 0, 0, 1)
		knockback_tween.parallel().tween_property(animation, "modulate", Color(1,1,1,1), duration)
	
	is_hurt = true
	await get_tree().create_timer(.3).timeout
	is_hurt = false

# Controls changes
func _on_signal_controls_changed(changes: Array[SignalBus.ControlChange], _value):
	control_inverted = changes.has(SignalBus.ControlChange.INVERT)

# Keys changes	
func _on_signal_keys_changed(changes: Array[SignalBus.KeyChange], value):
	keys_modified = changes.has(SignalBus.KeyChange.RANDOM)
	
	if changes.has(SignalBus.KeyChange.DISABLE): keys_disabled = value
	else: keys_disabled = []

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
