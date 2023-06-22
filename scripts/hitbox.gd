extends Area2D

@onready var enemy := $Enemy as CharacterBody2D

var inverted_control = false

func _on_body_entered(body: Node2D):
	if body.name == "Player":
		inverted_control = !inverted_control


