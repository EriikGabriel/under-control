extends Area2D
class_name FinishLevel

var is_leave_scene = false

@onready var transition_in = $"Transition In" as TransitionIn
@onready var shape: CollisionShape2D = $shape

@export var next_scene_name: String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
		is_leave_scene = next_scene_name != ""


func _on_body_entered(body: Node2D) -> void:
	if(body is Player):
		body.control_inverted = false
		body.direction = 1
		body.level_transition = true


func _on_body_exited(body: Node2D) -> void:
	if(body is Player):
		if(!is_leave_scene): 
			body.level_transition = false
		body.direction = 0
		set_deferred("monitoring", false)
		
		if(is_leave_scene): 
			transition_in.change_scene("res://levels/{scene}.tscn".format({"scene": next_scene_name}))
