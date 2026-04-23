extends Control

@export var nickname: String 
@export var camera: int = 3
@export var move_timer: Timer
@export var kill_sound: AudioStreamPlayer
@export var ai: int = 0
@export var killer: bool = false
@export var stage: int = 0

var time_to_kill: int
var anger: int = 1
var movement_random_number: int = 0

@onready var office: Control = $".."
@onready var animation_camera_static: AnimatedSprite2D = $"../UiPc/CamFeed/CameraStatic"
@onready var jumpscare_player:  AnimatedSprite2D= $"../../JumpscarePlayer"
@onready var sound_camera_buzz: AudioStreamPlayer = $"../CamBuzzSound"
@onready var button_shock: TextureButton = $"../UiPc/ShockButton"

func _on_move_timer_timeout() -> void:
	movement_random_number = randi_range(0, 20)
	if movement_random_number <= ai and ai > 0:
		stage = stage + 1
		office.camera_change()
		office.camera_static()
		if stage == 3:
			killer = true
			kill()


func kill():
	GlobalVars.cage_killer = true
	animation_camera_static.self_modulate.a = (100000)
	sound_camera_buzz.play()
	await get_tree().create_timer(1.5).timeout
	jumpscare_player.set_visible(true)
	jumpscare_player.play("cage_jumpscare")
	kill_sound.play()
	await get_tree().create_timer(1.5).timeout
	get_tree().change_scene_to_file("res://scenes/game_over_screen.tscn")


func _on_shock_button_pressed() -> void:
	if GlobalVars.camera_clicked == 3 and stage > 0:
		$"../UiPc/ShockButton/CageShock".play()
		stage = 0
		office.camera_static()
		office.camera_change()
