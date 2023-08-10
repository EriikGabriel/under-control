extends Node

class_name Damageable

@export var remove_node := false
@export var health := 3:
	get:
		return health
	set(value):
		if(value < 0): return
		SignalBus.on_health_changed.emit(get_parent(), value - health, value)
		health = value


func hit(damage: int):
	health -= damage
	
	if(health <= 0):
		if(remove_node): get_parent().queue_free()
