extends MarginContainer

var default = load("res://assets/UI/Cursors/default cursor.png")
var pointer = load("res://assets/UI/Cursors/pointer cursor.png")

@onready var start: Button = $CenterContainer/VBoxContainer/CenterContainer2/VBoxContainer/CenterContainer/Start

func _ready():
	start.grab_focus()

func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://levels/level_1.tscn")

func _on_exit_pressed() -> void:
	get_tree().quit()

func _on_start_mouse_entered() -> void:
	Input.set_custom_mouse_cursor(pointer)


func _on_credits_mouse_entered() -> void:
	Input.set_custom_mouse_cursor(pointer)


func _on_exit_mouse_entered() -> void:
	Input.set_custom_mouse_cursor(pointer)


func _on_start_mouse_exited() -> void:
	Input.set_custom_mouse_cursor(default)


func _on_credits_mouse_exited() -> void:
	Input.set_custom_mouse_cursor(default)


func _on_exit_mouse_exited() -> void:
	Input.set_custom_mouse_cursor(default)
