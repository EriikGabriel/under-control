extends Node

# When controls functionality is changed.
# example: invert controls 
enum ControlChange { INVERT }
signal on_controls_changed(changes: Array[ControlChange], value)

# When keys responsible for a feature are changed.
# example: switch movement keys to random keys
enum KeyChange { RANDOM = 2, DISABLE }
enum DisableKeys { KEY_LEFT, KEY_RIGHT, KEY_SPACE }
signal on_keys_changed(changes: Array[KeyChange], value)

# When an actor health changed
# example: player take damage or heal
signal on_health_changed(node: Node, amount_changed: int, current_health: int)
