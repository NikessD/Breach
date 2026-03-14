extends Control


@export var animatronic_name: String
@export var animatronic_sprite: Sprite2D
@export var label_animatronic: Label
@export var label_animatronic_ai: Label

var custom_ai: int 
var animatronic_background_speed: float = 0

@onready var animatronic_background: AnimatedSprite2D = $AnimatedSprite2D
@onready var button_clicked: AudioStreamPlayer = $ButtonClicked

func _ready():
	label_animatronic.text = str(animatronic_name)
	animatronic_background.set_speed_scale(0)


func animatronic_ai_value_changed():
	label_animatronic_ai.text = str(custom_ai)
	animatronic_background_speed = custom_ai
	animatronic_background.set_speed_scale(animatronic_background_speed/40)
	

func _on_button_add_pressed() -> void:
	button_clicked.play()
	if custom_ai < 20:
		custom_ai = custom_ai + 1
		animatronic_ai_value_changed()




func _on_button_subtract_pressed() -> void:
	button_clicked.play()
	if custom_ai > 0:
		custom_ai = custom_ai - 1
		animatronic_ai_value_changed()
