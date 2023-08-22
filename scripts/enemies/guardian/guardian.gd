extends CharacterBody2D
class_name Guardian

const SPEED = 700.0
const JUMP_VELOCITY = -400.0

# State animations flag's
var is_attacking = false
var is_death := false
var is_hurt := false

var knockback = Vector2.ZERO

var direction := 0

var controls_changes_array: Array[SignalBus.ControlChange] = []

@onready var animation: AnimatedSprite2D = $anim
@onready var distance_raycast: RayCast2D = $attack_distance
@onready var reload_timer: Timer = $attack_distance/reload_timer

@export var bullet: PackedScene
@export var bullet_reload := 2

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	SignalBus.on_controls_changed.connect(_on_controls_keys_changed)
	
	reload_timer.wait_time = bullet_reload

func _physics_process(delta):
	if(!is_on_floor()): velocity.y += gravity * delta
	
	if direction != 0:
		velocity.x = direction * SPEED * delta
		animation.scale.x = direction
		distance_raycast.scale.x = -direction
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	if knockback != Vector2.ZERO:
		velocity = knockback
	
	if(distance_raycast.is_colliding() && distance_raycast.get_collider()): 
		if(reload_timer.is_stopped()):
			distance_attack()
	
	move_and_slide()

func distance_attack():
	is_attacking = true
	distance_raycast.enabled = false
	reload_timer.start()
	
	var bullet_instance: SpellBullet = bullet.instantiate()
	add_child(bullet_instance)

func _invert_controls():
	if(!controls_changes_array.has(SignalBus.ControlChange.INVERT)):
		controls_changes_array.append(SignalBus.ControlChange.INVERT)
	SignalBus.on_controls_changed.emit(controls_changes_array, null)

func _reset_controls():
	controls_changes_array.erase(SignalBus.ControlChange.INVERT)
	SignalBus.on_controls_changed.emit(controls_changes_array, null)

func _on_controls_keys_changed(changes: Array[SignalBus.ControlChange], _value):
	controls_changes_array = changes

func _on_anim_animation_finished() -> void:
	match (animation.animation):
		"attack":
			is_attacking = false
		"hurt":
			is_hurt = false

func _on_reload_timer_timeout():
	distance_raycast.enabled = true
