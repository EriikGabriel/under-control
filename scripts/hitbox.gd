extends Area2D

var inverted_control = false
signal control_changed_direction


func _on_body_entered(body: Node2D):
	if body.name == "Player":
		inverted_control = !inverted_control
		emit_signal("control_changed_direction", inverted_control)
