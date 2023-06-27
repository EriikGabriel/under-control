extends Node2D

@onready var platform := $platform as Area2D

signal disable_key

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_platform_body_entered(body):
	print("collide")
	if body.name == "Player":
		emit_signal("disable_key", "RIGHT")


func _on_platform_body_exited(body):
	if body.name == "Player":
		emit_signal("disable_key", "")