extends Area2D

@onready var inimigo := $enemy as CharacterBody2D

var inverter = false
signal sentido_alterado

func _on_body_entered(body: Node2D):
	if body.name == "Player":
		print("Colidiu")
		inverter = !inverter
		emit_signal("sentido_alterado", inverter)

