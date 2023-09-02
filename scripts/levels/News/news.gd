extends Control

@onready var next_key: AnimatedSprite2D = $CenterContainer/next_key
@onready var transition_in = $"Transition In" as TransitionIn


func _ready() -> void:
	pass # Replace with function body.


func _process(delta: float) -> void:
	if(Input.is_action_pressed("interact")):
		next_key.play("press")
		
		transition_in.change_scene("res://levels/main_menu.tscn")
	else:
		next_key.play("default")
