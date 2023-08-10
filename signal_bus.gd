extends Node


# When controls functionality is changed.
# example: invert controls 
enum ControlChange { NORMAL, INVERT }
signal on_controls_changed(change: ControlChange)

# When keys responsible for a feature are changed.
# example: switch movement keys to random keys
enum KeyChange { NORMAL, RANDOM }
signal on_keys_changed(change: KeyChange)

# When an actor health changed
# example: player take damage or heal
signal on_health_changed(node: Node, amount_changed: int, current_health: int)
