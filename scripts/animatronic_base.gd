extends Node




@export var nickname: String 
@export var camera: int = 1
var anger: int = 1
var is_at_door: bool = false
var movement_random_number: int = 0
var close_roaming: int = 0






func _on_timer_timeout() -> void:
	move()
	


func at_door():
	GlobalVars.location.is_at_door = true



func get_cam(cam_i):
	match cam_i:
		1, 3:
			return 2
		2: 
			return randi_range(3,4)
		4:
			var side_choose = randi_range(1, 2)
			if side_choose == 1:
				return 5
			else:
				return 8
		5, 6: 
			$"../WalkSound".play()
			close_roaming = randi_range(1,2)
			if close_roaming == 1:
				GlobalVars.anger = randi_range(250,500)
				$KillTimer	.start()
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
	if movement_random_number <= GlobalVars.ricky_ai:
		var last_cam
		last_cam = camera
		camera = get_cam(camera)
		$"..".camera_change()
		if camera == GlobalVars.camera_clicked or GlobalVars.camera_clicked == last_cam:
			$"..".camera_movement_static()

		
func camera_7_compute():
	if GlobalVars.light_button_is_pressed and GlobalVars.view_left:
		$"../AnimationPlayerOffice".play("animation_view_left_scared_away")
		$"../RunningSound".play()
		#door_leave_sound()
		close_roaming = randi_range(1,3)
		if close_roaming == 1:
			return 5
		elif close_roaming == 2:
			return 6
		else:
			return 4
	else:
		$"../AnimationPlayerOffice".play("animation_jumpscare_left")
		kill()




func camera_8_compute() -> int:
	$"../WalkSound".play()
	close_roaming = randi_range(1,3)
	if close_roaming == 1:
		anger = randi_range(250,500)
		$KillTimer.start()
		if GlobalVars.light_button_is_pressed == true and GlobalVars.view_right == true:
			$"../AnimationPlayerOffice".play("animation_view_right_light_walk_in")
		return 11
	elif close_roaming == 2:
		return 9
	else:
		return 10


func camera_9_compute():
	$"../WalkSound".play()
	close_roaming = randi_range(1,3)
	if close_roaming == 1:
		return 10
	else:
		anger = randi_range(250,500)
		$"../KillTimer"	.start()
		if GlobalVars.light_button_is_pressed == true and GlobalVars.view_right == true:
			$"../AnimationPlayerOffice".play("animation_view_right_light_walk_in")
		return 11


func camera_10_compute():
	$"../WalkSound".play()
	close_roaming = randi_range(1,2)
	if close_roaming == 1:
		return 9
	else:
		anger = randi_range(250,500)
		$KillTimer.start()
		if GlobalVars.light_button_is_pressed == true and GlobalVars.view_right == true:
			$"../AnimationPlayerOffice".play("animation_view_right_light_walk_in")
		return 11

func camera_11_compute():
	if GlobalVars.light_button_is_pressed:
		$"../AnimationPlayerOffice".play("animation_view_right_scared_away")
		$"../RunningSound".play()
		#door_leave_sound()
		close_roaming = randi_range(1,2)
		if close_roaming == 1:
			return 8
		elif close_roaming == 1:
			return 9
		else:
			return 10
	else:
		$"../AnimationPlayerOffice".play("animation_jumpscare_right")
		kill()



func kill():
	$"../LightButton".set_visible(false)
	$"../UiPc".set_visible(false)
	$"../Buttons".set_visible(false)
	$KillTimer.stop()
	$"../../Scream".play()
	await get_tree().create_timer(0.7).timeout	
	get_tree().change_scene_to_file("res://scenes/game_over_screen.tscn")

func run_away():
	is_at_door = false
	anger = 0
	$"../TimerRooster".wait_time = 5
	$KillTimer.stop()
	
	
func _on_door_kill_timer_timeout() -> void:
	print(GlobalVars.anger)
	if(GlobalVars.light_button_is_pressed and is_at_door):
		anger -= 40	
	else:
		anger += 10	
	
	if(anger >= 750 and camera == 11):
		kill()	
	elif(anger >= 750 and camera == 7):
		kill()
		
	if(GlobalVars.light_button_is_pressed):
		if(GlobalVars.anger <= 250 and camera == 11):
			$"../AnimationPlayerOffice".play("animation_view_right_twithing")
		elif(GlobalVars.anger <= 250 and camera == 7):
			$"../AnimationPlayerOffice".play("animation_view_right_twithing")
			
	if(anger <= 0 ):
		match (camera):
			7:
				run_away()
				camera_7_compute()	
			11:
				run_away()
				camera_11_compute()	
