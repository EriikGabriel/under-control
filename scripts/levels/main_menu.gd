extends MarginContainer

@onready var start: Button = $CenterContainer/VBoxContainer/CenterContainer2/VBoxContainer/CenterContainer/Start

func _ready():
	start.grab_focus()


func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://levels/level_1.tscn")


func _on_exit_pressed() -> void:
	get_tree().quit()
 
