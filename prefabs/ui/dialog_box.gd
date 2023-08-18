extends MarginContainer
class_name DialogBox

const MAX_WIDTH = 256

var text = ""
var letter_index = 0

var letter_display_timer := 0.04
var space_display_timer := 0.05
var ponctuation_display_timer := 0.2

signal text_display_finished()

@onready var text_label: Label = $label_magin/text_label
@onready var letter_timer_display: Timer = $letter_timer_display

func display_text(text_to_display: String):
	text = text_to_display
	text_label.text = text_to_display
	
	await resized
	
	custom_minimum_size.x = min(size.x, MAX_WIDTH)
	
	if(size.x > MAX_WIDTH):
		text_label.autowrap_mode = TextServer.AUTOWRAP_WORD
		await resized
		await resized
		custom_minimum_size.y = size.y
	
	global_position.x -= size.x / 2
	global_position.y -= size.y + 30
	text_label.text = ""
	
	display_letter()

func display_letter():
	text_label.text += text[letter_index]
	letter_index += 1
	
	if(letter_index >= text.length()):
		text_display_finished.emit()
		return
	
	match text[letter_index]:
		"!", "?", ",", ".":
			letter_timer_display.start(ponctuation_display_timer)
		" ":
			letter_timer_display.start(space_display_timer)
		_:
			letter_timer_display.start(letter_display_timer)

func _on_letter_timer_display_timeout() -> void:
	display_letter()
