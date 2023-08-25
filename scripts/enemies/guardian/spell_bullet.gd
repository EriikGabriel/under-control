extends StaticBody2D
class_name SpellBullet

var speed := 80

var direction := Vector2.LEFT
var guardian: Guardian
var travel_distance: float

func _ready() -> void:
	guardian = get_parent()
	if(guardian.direction != 0): direction = Vector2(guardian.scale.x, 0)
	travel_distance = guardian.distance_raycast.target_position.x

func _physics_process(delta: float) -> void:
	var moviment = direction * speed * delta
	
	global_position += moviment
	
	if(position.x < travel_distance): queue_free()
		
func _on_hitbox_body_entered(body: Node2D) -> void:
	if(body is Player):
		for child in body.get_children():
				if child is Damageable:
					body.is_attacking = false
					
					child.hit(1, Vector2(-200 * guardian.scale.x, -200))
					
					if(!body.control_inverted):
						guardian._invert_controls()
					else:
						guardian._reset_controls()
					
					queue_free()
