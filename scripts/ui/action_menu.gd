extends CanvasLayer

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("menu"):
		visible = !visible
		get_tree().paused = visible



func _on_restart_pressed():
	get_tree().reload_current_scene()
