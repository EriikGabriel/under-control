extends Node2D

@onready var player := $Player as CharacterBody2D
@onready var camera := $Camera as Camera2D

func _ready():
	player.follow_camera(camera);

func _process(_delta):
	pass
