extends Area2D

@export var shape: CollisionShape2D
@export var damage := 1

func _on_body_entered(body: Node2D):
	for child in body.get_children():
		if child is Damageable:
			child.hit(damage)
