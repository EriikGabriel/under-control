extends Node
class_name Damageable

var knockback: Vector2 = Vector2.ZERO
var knockback_tween

var max_health := 3

@export var animation: AnimatedSprite2D
@export var remove_node := false
@export var health := 3:
	get:
		return health
	set(value):

		if(value < 0 || value > max_health): return
		SignalBus.on_health_changed.emit(get_parent(), value - health, value)
		health = value

func _ready():
	animation.animation_finished.connect(_on_animation_finished)
	
	max_health = health
	


func hit(damage: int, knockback_strength := Vector2.ZERO, duration := 0.25):
	health -= damage
	
	get_parent().is_hurt = true

	if(knockback_strength != Vector2.ZERO):
		knockback = knockback_strength
		
		knockback_tween = get_tree().create_tween()
		knockback_tween.parallel().tween_property(get_parent(), "knockback", Vector2.ZERO, duration)
		
		animation.modulate = Color(1, 0, 0, 1)
		knockback_tween.parallel().tween_property(animation, "modulate", Color(1,1,1,1), duration)
		
		get_parent().knockback = knockback
	
	if(health <= 0):
		get_parent().is_death = true

func heal(quantity: int):
	health += quantity

func _on_animation_finished():
	if(animation.animation == "death" && remove_node):
		get_parent().queue_free()
