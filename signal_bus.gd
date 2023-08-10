extends Node

# When controls functionality is changed.
# example: invert controls 
enum ControlChange { NORMAL = 0, INVERT }
signal on_controls_changed(changes: Array[ControlChange])

# When keys responsible for a feature are changed.
# example: switch movement keys to random keys
enum KeyChange { NORMAL = 2, RANDOM }
signal on_keys_changed(changes: Array[KeyChange])

# When an actor health changed
# example: player take damage or heal
signal on_health_changed(node: Node, amount_changed: int, current_health: int)
