extends CharacterBody2D
class_name Butcher

const SPEED = 700.0
const JUMP_VELOCITY = -400.0

# State animations flag's
var is_attacking = false
var is_death := false
var is_hurt := false

var knockback = Vector2.ZERO

var direction := -1

@onready var animation := $anim as AnimatedSprite2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	SignalBus.on_health_changed.connect(_on_signal_health_changed)

func _physics_process(delta):
	if(!is_on_floor()): velocity.y += gravity * delta
	
	if direction != 0:
		velocity.x = direction * SPEED * delta
		animation.scale.x = direction
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	if knockback != Vector2.ZERO:
		velocity = knockback
		
	if(!is_death): move_and_slide()

# When player enter in attack area
func _on_attack_area_body_entered(body: Node2D) -> void:
	if body is Player:
		is_attacking = true

		if(body.raycast_left.is_colliding() || body.raycast_right.is_colliding()):
			var knockback_vector = Vector2.ZERO
			
			if body.raycast_right.is_colliding():
				knockback_vector = Vector2(-200, -200)
			else: 
				knockback_vector = Vector2(200, -200)

			for child in body.get_children():
				if child is Damageable: child.hit(1, knockback_vector)

# Health changes
func _on_signal_health_changed(node: Node, _amount_changed: int, current_health: int):
	if(node is Butcher && current_health == 0):
		set_collision_layer_value(3, false)

func _on_anim_animation_finished():
	match (animation.animation):
		"attack":
			is_attacking = false
		"hurt":
			is_hurt = false
