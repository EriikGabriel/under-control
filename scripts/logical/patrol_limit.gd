extends Area2D
class_name PatrolLimits

@export var actor: CharacterBody2D

func _on_body_entered(body: Node2D) -> void:
	if(body == actor): invert_actor_direction()

func invert_actor_direction():
	actor.direction *= -1
	actor.animation.flip_h = !actor.animation.flip_h
	actor.scale.x *= -1
