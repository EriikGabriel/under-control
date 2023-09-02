extends CanvasLayer

@onready var overlay: ColorRect = $Overlay
@onready var shadow: ColorRect = $Shadow

var scene_tween: Tween


func _ready() -> void:

	scene_tween = get_tree().create_tween()
	scene_tween.tween_property(overlay, "progress", 1, 0).set_trans(Tween.TRANS_QUINT)
	
	scene_tween.finished.connect(_revert_tween)
	
	

func _revert_tween():
	
	scene_tween = get_tree().create_tween()
	scene_tween.tween_property(overlay, "progress", 0, 2).set_trans(Tween.TRANS_QUINT)
