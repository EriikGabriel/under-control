extends Node2D

@onready var platform := $platform as Area2D

signal disable_keys

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _on_platform_body_entered(body):
	if body.name == "Player":
		var keys: Array[String] = ["KEY_RIGHT", "KEY_SPACE"]
		emit_signal("disable_keys", keys)

func _on_platform_body_exited(body):
	if body.name == "Player":
		emit_signal("disable_keys", [] as Array[String])
