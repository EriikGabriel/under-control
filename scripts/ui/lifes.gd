extends Control

@export var heart: PackedScene

@onready var player: Player = $"%Player"

var player_health = 3

func _ready() -> void:
	SignalBus.on_health_changed.connect(on_signal_health_changed)
	
	for child in player.get_children():
		if(child is Damageable): player_health = child.health
	
	var pos_x = -12
	for i in player_health:
		var heart_instance: AnimatedSprite2D = heart.instantiate()
		heart_instance.position = Vector2(pos_x, -4)
		add_child(heart_instance)
		pos_x += 9

func _process(_delta: float) -> void:
	pass

func on_signal_health_changed(node: Node, _amount_changed: int, current_health: int):
	if(node is Player):
		var hearts = get_children() as Array[AnimatedSprite2D]
		for i in hearts.size():
			var child = hearts[i]
			if(i >= current_health): child.play("empty")
			else: child.play("default")

