extends CharacterBody2D
class_name Butcher

const SPEED = 700.0
const JUMP_VELOCITY = -400.0

# State animations flag's
var is_attacking = false

var direction := -1

@onready var animation := $anim as AnimatedSprite2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	pass

func _physics_process(delta):
	if not is_on_floor(): velocity.y += gravity * delta
	
	if direction != 0:
		velocity.x = direction * SPEED * delta
		animation.scale.x = direction
	
	move_and_slide()
	
func _on_attack_area_body_entered(body: Node2D) -> void:
	if body is Player:
		is_attacking = true
		await get_tree().create_timer(0.5).timeout
		is_attacking = false

		if(body.raycast_left.is_colliding() || body.raycast_right.is_colliding()):
			for child in body.get_children():
				if child is Damageable:
					child.hit(1)

