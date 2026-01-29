extends Node

class_name Animatronic



@export var nickname: String 
@export var camera: int = 1
@export var move_timer: Timer
@export var kill_timer: Timer
@export var kill_sound: AudioStreamPlayer
@export var ai: int = 0
var door_side: int = 0
var anger: int = 1
var is_at_door: bool = false
var movement_random_number: int = 0
var close_roaming: int = 0
var previous_side: int = 0



func _on_move_timer_timeout() -> void:
	move()


func get_cam(cam_i):
	match cam_i:
		1, 3:
			return 2
		2: 
			return randi_range(3,4)
		4:
			var side_choose = randi_range(1, 2)
			if previous_side == side_choose:
				var side_mixer = randi_range(1,3)
				if side_mixer != previous_side:
					if previous_side == 1:
						previous_side = 2
						return 8
					else:
						previous_side = 1
						return 5
				else:
					if previous_side == 1:
						previous_side = 1
						return 5
					else:
						previous_side = 1
						return 8
			else:	
				if side_choose == 1:
					previous_side = 1
					return 5
				else:
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
				if GlobalVars.light_button_is_pressed == true and GlobalVars.view_left == true:
					$"../AnimationPlayerOffice".play("animation_view_left_light_walk_in")
				return 7
			else:
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
		$"..".camera_change()
		if camera == GlobalVars.camera_clicked or GlobalVars.camera_clicked == last_cam:
			$"..".camera_static()
	elif movement_random_number <= ai:
		var last_cam
		last_cam = camera
		camera = get_cam(camera)
		$"..".camera_change()
		if camera == GlobalVars.camera_clicked or GlobalVars.camera_clicked == last_cam:
			$"..".camera_static()

		
func camera_7_compute():
	if anger <= 0:
		print("utekl")
		$"../AnimationPlayerOffice".play("animation_view_left_scared_away")
		$"../RunningSound".play()
		#door_leave_sound()
		close_roaming = randi_range(1,8)
		if close_roaming == 1:
			is_at_door = false
			return 5
		elif close_roaming == 2:
			is_at_door = false
			return 6
		else:
			is_at_door = false
			return 4
	else:
		kill()
		return 7



func camera_8_compute() -> int:
	close_roaming = randi_range(1,3)
	if close_roaming == 1:
		anger = randi_range(250,500)
		move_timer.stop()
		$KillTimer.start()
		door_side = 2
		if GlobalVars.light_button_is_pressed == true and GlobalVars.view_right == true:
			$"../AnimationPlayerOffice".play("animation_view_right_light_walk_in")
		return 11
	elif close_roaming == 2:
		return 9
	else:
		return 10


func camera_9_compute():
	close_roaming = randi_range(1,3)
	if close_roaming == 1:
		return 10
	else:
		door_side = 2
		anger = randi_range(250,500)
		move_timer.stop()
		kill_timer.start()
		is_at_door = true
		if GlobalVars.light_button_is_pressed == true and GlobalVars.view_right == true:
			$"../AnimationPlayerOffice".play("animation_view_right_light_walk_in")
		return 11


func camera_10_compute():
	close_roaming = randi_range(1,2)
	if close_roaming == 1:
		return 9
	else:
		door_side = 2
		anger = randi_range(250,500)
		kill_timer.start()
		is_at_door = true
		if GlobalVars.light_button_is_pressed == true and GlobalVars.view_right == true:
			$"../AnimationPlayerOffice".play("animation_view_right_light_walk_in")
		return 11

func camera_11_compute():
	if anger <= 0:
		$"../AnimationPlayerOffice".play("animation_view_right_scared_away")
		$"../RunningSound".play()
		#door_leave_sound()
		close_roaming = randi_range(1,8)
		if close_roaming == 1:
			is_at_door = false
			return 8
		elif close_roaming == 2:
			is_at_door = false
			return 9
		else:
			is_at_door = false
			return 4
	else:
		kill()
		return 11



func kill():
	$"../LightButton".set_visible(false)
	$"../UiPc".set_visible(false)
	$"../Buttons".set_visible(false)
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
	print(str(anger))
	if(anger <= 0 ):
		match camera:
			7:
				run_away()
				move()
				is_at_door = false
			11:
				run_away()
				move()
				is_at_door = false
	elif anger >= 750:
		kill()
		
	if(GlobalVars.light_button_is_pressed):
		if(GlobalVars.light_button_is_pressed and door_side == 1 and GlobalVars.view_left):
			anger -= 40	
		
		elif(GlobalVars.light_button_is_pressed and door_side == 2 and GlobalVars.view_right):
			anger -= 40	
	else:
		anger += 20
		
		if(anger <= 250 and camera == 11):
			$"../AnimationPlayerOffice".play("animation_view_right_twithing")
		elif(anger <= 250 and camera == 7):
			$"../AnimationPlayerOffice".play("animation_view_left_twithing")
			
