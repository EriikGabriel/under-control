extends Node2D

const FALL_LIMIT = 600.0

@onready var player := $Player as CharacterBody2D
@onready var camera := $Camera as Camera2D
@onready var transition_in = $"Transition In" as TransitionIn

var is_fall = false

func _ready():
	player.follow_camera(camera);

func _process(_delta: float) -> void:
	player_fall()

func player_fall():
	if(player.position.y >= FALL_LIMIT && !is_fall):
		transition_in.change_scene("res://game.tscn", 0.5)
