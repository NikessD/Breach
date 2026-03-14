extends Node

class_name Animatronic

## AI pro animatronika ricky.

@export var nickname: String 
@export var camera: int = 1
@export var move_timer: Timer
@export var kill_timer: Timer
@export var kill_sound: AudioStreamPlayer
@export var ai: int = 0
@export var sound_door_runaway: AudioStreamPlayer

var door_side: int = 0
var anger: int = 1
var is_at_door: bool = false
var movement_random_number: int = 0
var close_roaming: int = 0
var previous_side: int = 0

@onready var node_office: Control = $".."
@onready var jumpscare_player: AnimatedSprite2D = $"../../JumpscarePlayer"
@onready var animationplayer_office: AnimatedSprite2D = $"../AnimationPlayerOffice"


func _on_move_timer_timeout() -> void:
	move()


func get_cam(cam_i):
	match cam_i:
		1:
			return 2
		2: 
			return 4
		4:
			var side_choose = randi_range(1, 2)
			if previous_side == side_choose:
				var side_mixer = randi_range(1,3)
				if side_mixer != previous_side:
					if previous_side == 1:
						previous_side = 2
						return 8
					previous_side = 1
					return 5
				else:
					if previous_side == 1:
						previous_side = 1
						return 5
					previous_side = 1
					return 8
			else:	
				if side_choose == 1:
					previous_side = 1
					return 5
				previous_side = 2
				return 8
		5, 6: 
			close_roaming = randi_range(1,2)
			if close_roaming == 1:
				anger = randi_range(250,500)
				kill_timer.start()
				door_side = 1
				move_timer.stop()
				is_at_door = true
				if GlobalVars.light_button_is_pressed and GlobalVars.view_left:
					animationplayer_office.play("animation_view_left_light_walk_in")
				return 7
			return 6			
		7:
			return camera_7_compute()
		8:
			return camera_8_compute()
		9:
			return camera_9_compute()
		10:
			return camera_10_compute()
		11:	
			return camera_11_compute()


func move():
	movement_random_number = randi_range(0,20)
	if is_at_door:
		var last_cam
		last_cam = camera
		camera = get_cam(camera)
		node_office.camera_change()
		if camera == GlobalVars.camera_clicked or GlobalVars.camera_clicked == last_cam:
			node_office.camera_static()
	elif movement_random_number <= ai:
		var last_cam
		last_cam = camera
		camera = get_cam(camera)
		node_office.camera_change()
		if camera == GlobalVars.camera_clicked or GlobalVars.camera_clicked == last_cam:
			node_office.camera_static()


func camera_7_compute():
	if anger <= 0:
		animationplayer_office.play("animation_view_left_scared_away")
		sound_door_runaway.play()
		close_roaming = randi_range(1,8)
		is_at_door = false
		if close_roaming == 1:
			return 5
		elif close_roaming == 2:
			return 6
		return 4
	kill()
	return 7


func camera_8_compute() -> int:
	close_roaming = randi_range(1,3)
	if close_roaming == 1:
		anger = randi_range(250,500)
		move_timer.stop()
		$KillTimer.start()
		door_side = 2
		if GlobalVars.light_button_is_pressed and GlobalVars.view_right:
			animationplayer_office.play("animation_view_right_light_walk_in")
		return 11
	elif close_roaming == 2:
		return 9
	return 10


func camera_9_compute():
	close_roaming = randi_range(1,3)
	if close_roaming == 1:
		return 10
	door_side = 2
	
	anger = randi_range(250,500)
	move_timer.stop()
	kill_timer.start()
	is_at_door = true
	if GlobalVars.light_button_is_pressed and GlobalVars.view_right:
		animationplayer_office.play("animation_view_right_light_walk_in")
	return 11


func camera_10_compute():
	close_roaming = randi_range(1,2)
	if close_roaming == 1:
		return 9
	door_side = 2
	anger = randi_range(250,500)
	kill_timer.start()
	is_at_door = true
	if GlobalVars.light_button_is_pressed and GlobalVars.view_right:
		animationplayer_office.play("animation_view_right_light_walk_in")
	return 11


func camera_11_compute():
	if anger <= 0:
		animationplayer_office.play("animation_view_right_scared_away")
		sound_door_runaway.play()
		#door_leave_sound()
		close_roaming = randi_range(1,8)
		is_at_door = false
		if close_roaming == 1:
			return 8
		elif close_roaming == 2:
			return 9
		return 4
	kill()
	return 11


func kill():
	GlobalVars.ricky_killer = true
	$"../LightButton".set_visible(false)
	$"../UiPc".set_visible(false)
	$"../ViewMoveButtons".set_visible(false)
	move_timer.stop()
	kill_timer.stop()
	kill_sound.play()
	$"../../JumpscarePlayer".set_visible(true)
	$"../../JumpscarePlayer".play("ricky_jumpscare")
	await get_tree().create_timer(1.2).timeout	
	get_tree().change_scene_to_file("res://scenes/game_over_screen.tscn")


func run_away():
	move_timer.start(5)
	kill_timer.stop()
	door_side = 0
	anger = 0
	move_timer.wait_time = 5


func _on_kill_timer_timeout() -> void:
	if(GlobalVars.light_button_is_pressed):
		if(GlobalVars.light_button_is_pressed and door_side == 1 and GlobalVars.view_left):
			anger -= 40	
		elif(GlobalVars.light_button_is_pressed and door_side == 2 and GlobalVars.view_right):
			anger -= 40	
	else:
		anger += 20
		if(anger <= 250 and camera == 11):
			animationplayer_office.play("animation_view_right_twithing")
		elif(anger <= 250 and camera == 7):
			animationplayer_office.play("animation_view_left_twithing")

	if anger <= 0 :
		run_away()
		move()
		is_at_door = false
	elif anger >= 750:
		kill()
