extends CharacterBody2D

const SPEED = 700.0
const JUMP_VELOCITY = -400.0

# State animations flag's
var is_running = false
var is_attacking = false

var direction := -1

@onready var animation := $anim as AnimatedSprite2D

var control_inverted := false
var attack_finished := false

var controls_changes_array: Array[SignalBus.ControlChange] = []

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	SignalBus.on_controls_changed.connect(_on_controls_keys_changed)

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	velocity.x = direction * SPEED * delta

	_set_state()
	move_and_slide()
	
func _on_controls_keys_changed(changes: Array[SignalBus.ControlChange]):
	controls_changes_array = changes

func _on_anim_animation_finished():
#	emit_signal("enemy_attack", self)
	attack_finished = true

func _on_spell_area_body_entered(body: Node2D) -> void:
	if body is Player:
		is_attacking = true
		await get_tree().create_timer(0.5).timeout
		is_attacking = false
		
		if(control_inverted):
			_reset_controls()
			control_inverted = false
		else:
			_invert_controls()
			control_inverted = true

		for child in body.get_children():
			if child is Damageable:
				child.hit(1)

func _set_state():
	var state = "idle"
	
	if !is_on_floor():
		state = "idle"
	elif direction != 0:
		state = "running"

	if is_attacking:
		state = "attacking"

	if animation.animation != state:
		animation.play(state)

func _invert_controls():
	if(!controls_changes_array.has(SignalBus.ControlChange.INVERT)):
		controls_changes_array.append(SignalBus.ControlChange.INVERT)
	SignalBus.on_controls_changed.emit(controls_changes_array)

func _reset_controls():
	controls_changes_array.clear()
	controls_changes_array.append(SignalBus.ControlChange.NORMAL)
	SignalBus.on_controls_changed.emit(controls_changes_array)
