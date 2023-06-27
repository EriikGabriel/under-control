extends CharacterBody2D

const SPEED = 100.0
const JUMP_FORCE = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var is_jumping = false
var is_death = false
var knockback_vector = Vector2.ZERO

# Control flag's
var inverted_control = false
var disabled_key

@export var player_life := 10

@onready var animation := $anim as AnimatedSprite2D
@onready var remote_tranform := $remote as RemoteTransform2D
@onready var raycast_right := $raycast_right as RayCast2D
@onready var raycast_left := $raycast_left as RayCast2D 
@onready var colision := $collision as CollisionShape2D
@onready var hurtbox := $hurtbox as Area2D
@onready var enemy := $"/root/World-1/Enemy" as CharacterBody2D
@onready var platform := $"/root/World-1/Platform" as StaticBody2D

func _ready():
	# Conecta o sinal para receber notificações de alteração
	enemy.enemy_attack.connect(_on_hurtbox_body_entered)
	platform.disable_key.connect(on_disable_key)
	

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	
	# Handle Jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_FORCE
		is_jumping = true
	elif is_on_floor():
		is_jumping = false

	var direction = Input.get_axis("move_left", "move_right")
	
	if disabled_key == "RIGHT" && direction > 0: direction = 0
	
	if inverted_control:
		direction *= -1

	if !is_death: 
		if is_jumping:
			animation.play("jumping")
		elif direction:
			velocity.x = direction * SPEED
			animation.scale.x = direction
			animation.play("running")
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			animation.play("idle")

		if knockback_vector != Vector2.ZERO:
			velocity = knockback_vector

		move_and_slide()


func _on_hurtbox_body_entered(body: Node2D) -> void:
	if player_life <= 1:
		animation.play('death')
		is_death = true
		colision.disabled = true
		hurtbox.monitoring = false
	else:
		if raycast_right.is_colliding():
			take_damage(Vector2(-200, -200))
		elif raycast_left.is_colliding():
			take_damage(Vector2(200, -200))
	
	if body.is_in_group("guardians"): 
		inverted_control = !inverted_control

func follow_camera(camera):
	var camera_path = camera.get_path()
	remote_tranform.remote_path = camera_path

func take_damage(knockback_force := Vector2.ZERO, duration := 0.25):
	player_life -= 1
	
	if knockback_force != Vector2.ZERO:
		var knockback_tween := get_tree().create_tween()
		
		knockback_vector = knockback_force 
		knockback_tween.parallel().tween_property(self, "knockback_vector", Vector2.ZERO, duration)
		animation.modulate = Color(1, 0, 0, 1)
		knockback_tween.parallel().tween_property(animation, "modulate", Color(1,1,1,1), duration)

func on_control_changed_direction(direction_inverted):
	inverted_control = direction_inverted
	
func on_disable_key(key):
	disabled_key = key


