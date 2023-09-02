extends Area2D

@onready var texture: Sprite2D = $warning/texture
@onready var warning: Node2D = $warning

@export_multiline var lines: Array[String] 

func _unhandled_input(event: InputEvent) -> void:
	if(get_overlapping_bodies().size()):
		texture.show()
		if(event.is_action_pressed("interact") && !DialogManager.is_message_active):
			print()
			texture.hide()
			DialogManager.start_message(warning.global_position, lines)
	else:
		texture.hide()
		if(DialogManager.dialog_box != null):
			DialogManager.dialog_box.queue_free()
			DialogManager.is_message_active = false
