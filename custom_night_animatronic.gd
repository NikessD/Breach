extends Control


@export var animatronic_name: String
@export var animatronic_sprite: Sprite2D
@export var label_animatronic: Label
@export var label_animatronic_ai: Label

var custom_ai: int 


func _ready():
	label_animatronic.text = str(animatronic_name)



func _on_button_add_pressed() -> void:
	if custom_ai < 20:
		custom_ai = custom_ai + 1
		label_animatronic_ai.text = str(custom_ai)


func _on_button_subtract_pressed() -> void:
	if custom_ai > 0:
		custom_ai = custom_ai - 1
		label_animatronic_ai.text = str(custom_ai)
