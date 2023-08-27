extends Node2D

const WAIT_DURATION := 1.0
@onready var anim: AnimatedSprite2D = $platform/anim
@onready var platform := $platform as AnimatableBody2D
@export var move_speed := 3.0
@export var distance := 192
@export var move_horizontal := true

var follow := Vector2.ZERO
var platform_center := 16


func _ready():
	move_platform()

func _physics_process(_delta: float) -> void:
	platform.position = platform.position.lerp(follow, 0.5)

func move_platform():
	anim.play("horizontal") if move_horizontal else anim.play("vertical")
	
	var move_direction = Vector2.RIGHT * distance if move_horizontal else Vector2.UP * distance
	var duration = move_direction.length() / float(move_speed * platform_center)
	
	var platform_tween = create_tween().set_loops().set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	platform_tween.tween_property(self, "follow", move_direction, duration).set_delay(WAIT_DURATION)
	platform_tween.tween_property(self, "follow", Vector2.ZERO, duration).set_delay(duration + WAIT_DURATION * 2)
