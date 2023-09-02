extends StaticBody2D

enum DisableKeys { KEY_LEFT, KEY_RIGHT, KEY_SPACE }

var keys_changes_array: Array[SignalBus.KeyChange] = []

@export var keys_disable: Array[SignalBus.DisableKeys]

func _ready():
	SignalBus.on_keys_changed.connect(_on_signal_keys_changed)

func _on_area_body_entered(body: Node2D) -> void:
	if (body is Player):
		if (!keys_changes_array.has(SignalBus.KeyChange.DISABLE)):
			keys_changes_array.append(SignalBus.KeyChange.DISABLE)
		SignalBus.on_keys_changed.emit(keys_changes_array, keys_disable)

func _on_area_body_exited(body: Node2D) -> void:
	if (body is Player):
		keys_changes_array.erase(SignalBus.KeyChange.DISABLE)
		SignalBus.on_keys_changed.emit(keys_changes_array, null)

func _on_signal_keys_changed(changes: Array[SignalBus.KeyChange], _value):
	keys_changes_array = changes
	

