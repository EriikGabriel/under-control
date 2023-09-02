extends CharacterBody2D
class_name Cat

var is_healing = false

var player: Player


@onready var animation: AnimatedSprite2D = $anim
@onready var heal_distance: RayCast2D = $"heal distance"

@export var heal_is_over = false

func _process(_delta: float) -> void:
	if(!heal_is_over && heal_distance.is_colliding() && Input.is_action_just_pressed("interact")):
		player = heal_distance.get_collider()
		
		player.visible = false
		player.is_healing = true
		is_healing = true
		
		for child in player.get_children():
			if(child is Damageable):
				child.heal(1)
				heal_is_over = true

func _on_anim_animation_finished() -> void:
	match (animation.animation):
		"life":
			is_healing = false
			player.visible = true
			player.is_healing = false
