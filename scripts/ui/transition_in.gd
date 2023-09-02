extends CanvasLayer
class_name TransitionIn

@onready var overlay: ColorRect = $Overlay

var scene_tween_in: Tween
var scene_tween_out: Tween


var scene_path: NodePath
var transition_delay: float

func change_scene(path: NodePath, delay := 2.0):
	scene_path = path
	transition_delay = delay
	
	scene_tween_in = get_tree().create_tween()
	scene_tween_in.tween_property(overlay, "progress", 1, delay).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_IN_OUT)
	
	scene_tween_in.finished.connect(_tween_in_finished)
	
	
func _tween_in_finished():
	get_tree().change_scene_to_file(scene_path)


