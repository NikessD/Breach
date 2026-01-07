extends Control

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


@onready var office = $".."



func kill():
	anger_timer.stop()
	await get_tree().create_timer(2).timeout
	$AngrySound.play()
	await get_tree().create_timer(8).timeout
	$"../AnimationPlayerOffice".play("animation_golden_s_death")
	kill_sound.play()
	await get_tree().create_timer(1.5).timeout
	get_tree().change_scene_to_file("res://scenes/game_over_screen.tscn")



func _on_anger_timer_timeout() -> void:
	if (anger > 299):
		print("aktiviváno")
		killer = true
		office.blackout()
		anger_timer.stop()
		move_timer.stop()
	elif (GlobalVars.camera_clicked == camera):
		anger += 20
	else:
		anger_timer.stop()
	
	
func _on_move_timer_timeout() -> void:
	camera = 0
	movement_random_number = randi_range(0, 20)
	if movement_random_number <= ai and ai > 0:
		camera = randi_range(0, 10)
		@warning_ignore("integer_division")
		anger = randi_range(80, 120) / ai
		await get_tree().create_timer(time_to_kill).timeout
	else:
		pass
