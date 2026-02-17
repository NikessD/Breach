extends Control

## AI pro animatronika ardent.

@export var nickname: String 
@export var camera: int = 1
@export var move_timer: Timer
@export var kill_timer: Timer
@export var anger_timer: Timer
@export var kill_sound: AudioStreamPlayer
@export var ai: int = 0
@export var killer: bool = false

var time_to_kill: int
var anger: int = 1
var movement_random_number: int = 0

@onready var office: Control = $".."
@onready var sprite_camera_ardent: Sprite2D = $"../UiPc/CamFeed/Ardent"
@onready var animation_camera_static: AnimatedSprite2D = $"../UiPc/CamFeed/CameraStatic"
@onready var jumpscare_player:  AnimatedSprite2D= $"../../JumpscarePlayer"
@onready var sound_camera_buzz: AudioStreamPlayer = $"../CamBuzzSound"


func kill():
	sprite_camera_ardent.set_visible(false)
	animation_camera_static.self_modulate.a = (100000)
	sound_camera_buzz.play()
	anger_timer.stop()
	await get_tree().create_timer(1.5).timeout
	jumpscare_player.set_visible(true)
	jumpscare_player.play("ardent_jumpscare")
	kill_sound.play()
	await get_tree().create_timer(1.5).timeout
	get_tree().change_scene_to_file("res://scenes/game_over_screen.tscn")


func _on_anger_timer_timeout() -> void:
	if (anger > 299):
		print("aktiviváno")
		killer = true
		kill()
		anger_timer.stop()
		move_timer.stop()
	elif (GlobalVars.camera_clicked == camera and GlobalVars.view_front):
		anger += 20
	else:
		anger_timer.stop()


func _on_move_timer_timeout() -> void:
	camera = 0
	movement_random_number = randi_range(0, 20)
	if movement_random_number <= ai and ai > 0:
		var camera_choose = randi_range(1, 5)
		match camera_choose:
			1:
				camera = 4
			2:
				camera = 5
			3:
				camera = 6
			4:
				camera = 8
			5:
				camera = 9
		@warning_ignore("integer_division")
		anger = randi_range(80, 120) / ai
		await get_tree().create_timer(time_to_kill).timeout
	else:
		pass
