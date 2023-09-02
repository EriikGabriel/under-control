extends Control

@export var rune: PackedScene

var spells: Array

func _ready() -> void:
	SignalBus.on_controls_changed.connect(_on_signal_controls_changed)
	SignalBus.on_keys_changed.connect(_on_signal_keys_changed)
	
	spells = []
	
	var controls_spell_count = SignalBus.ControlChange.size()
	var keys_spell_count = SignalBus.KeyChange.size()
	var spell_count = controls_spell_count + keys_spell_count
	
	var pos_x = -25
	for i in spell_count:
		var rune_instance = rune.instantiate() as AnimatedSprite2D
		rune_instance.position = Vector2(pos_x, -8)
		rune_instance.visible = false
		add_child(rune_instance)
		pos_x += 20

func _on_signal_controls_changed(changes: Array[SignalBus.ControlChange], _value):
	var key_spells_array = []
	
	# Get all spells of type key
	for spell in spells:
		if(SignalBus.KeyChange.find_key(spell)): 
			key_spells_array.append(spell)

	spells.clear()
	spells.append_array(key_spells_array)
	
	for change in changes:
		if (!spells.has(change)): spells.append(change)

	for child in get_children(): child.visible = false

	for i in spells.size():
		var spell = SignalBus.ControlChange.find_key(spells[i])
		var anim_name = str(spell).to_lower()
		var child = get_child(i) as AnimatedSprite2D
		if(spell): child.play(anim_name)
		child.visible = true

func _on_signal_keys_changed(changes: Array[SignalBus.KeyChange], _value):
	var control_spells_array = []
	
	# Get all spells of type control
	for spell in spells:
		if(SignalBus.ControlChange.find_key(spell)): 
			control_spells_array.append(spell)

	spells.clear()
	spells.append_array(control_spells_array)
	
	for change in changes:
		if (!spells.has(change)): spells.append(change)

	for child in get_children(): child.visible = false
	
	for i in spells.size():
		var spell = SignalBus.KeyChange.find_key(spells[i])
		var anim_name = str(spell).to_lower()
		var child = get_child(i) as AnimatedSprite2D
		if(spell): child.play(anim_name)
		child.visible = true
