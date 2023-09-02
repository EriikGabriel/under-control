extends Area2D

@export var shape: CollisionShape2D
@export var damage := 1

var knockback = Vector2.ZERO

func _on_body_entered(body: Node2D):
	if(get_parent().is_death): return
	
	if(body is Player):
		knockback = Vector2(-300 * body.hitbox.scale.x, -200)
		
	for child in body.get_children():
		if child is Damageable: child.hit(damage, knockback)
