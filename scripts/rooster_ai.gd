extends Control
class_name RoosterAi

# player var
#var head_position = "stred"


# Animatronic rooster var
var animatronic_random_number
var animatronic_rooster_camera = 1
var animatronic_rooster_door_var = 0


func _init(starting_random_number: int) -> void:
	animatronic_random_number = starting_random_number

func _ready() -> void:
	pass
func _process(_delta: float) -> void:
	pass
func CamMovementStatic():
	$"../Office/UiPc/CamFeed/CameraStatic".self_modulate.a = (10)
	$"../Office/CamBuzzSound".play()
	await get_tree().create_timer(0.5).timeout	
	$"../Office/UiPc/CamFeed/CameraStatic".self_modulate.a = (0.2)

	
func Cam_Change():
	$"../Office/UiPc/Cameras".text =  "CAM " + str(GlobalVars.camera_ID) 
	
	if (GlobalVars.camera_clicked == animatronic_rooster_camera):
		match GlobalVars.camera_clicked:
				1:
					$"../Office/UiPc/CamFeed/CameraFeed".play("Cam1Animatronic")
				2:
					$"../Office/UiPc/CamFeed/CameraFeed".play("Cam2Animatronic")
				3:
					$"../Office/UiPc/CamFeed/CameraFeed".play("Cam3Animatronic")
				4:
					$"../Office/UiPc/CamFeed/CameraFeed".play("Cam4Animatronic")
				5:
					$"../Office/UiPc/CamFeed/CameraFeed".play("Cam5Animatronic")
				6:
					$"../Office/UiPc/CamFeed/CameraFeed".play("Cam6Animatronic")
				8:
					$"../Office/UiPc/CamFeed/CameraFeed".play("Cam7Animatronic")
				9:
					$"../Office/UiPc/CamFeed/CameraFeed".play("Cam8Animatronic")
				10:
					$"../Office/UiPc/CamFeed/CameraFeed".play("Cam9")
					
	elif (GlobalVars.camera_clicked != animatronic_rooster_camera):
		match GlobalVars.camera_clicked:
			1:
				$"../Office/UiPc/CamFeed/CameraFeed".play("Cam1Nothing")
			2:
				$"../Office/UiPc/CamFeed/CameraFeed".play("Cam2Nothing")
			3:
				$"../Office/UiPc/CamFeed/CameraFeed".play("Cam3Nothing")
			4:
				$"../Office/UiPc/CamFeed/CameraFeed".play("Cam4Nothing")
			5:
				$"../Office/UiPc/CamFeed/CameraFeed".play("Cam5Nothing")
			6:
				$"../Office/UiPc/CamFeed/CameraFeed".play("Cam6Nothing")
			8:
				$"../Office/UiPc/CamFeed/CameraFeed".play("Cam7Nothing")
			9:
				$"../Office/UiPc/CamFeed/CameraFeed".play("Cam8Nothing")
			10:
				$"../Office/UiPc/CamFeed/CameraFeed".play("Cam9")
				
	if GlobalVars.camera_clicked == 10:
		$"../Office/CamBuzzSound".play()
	else:
		$"../Office/CamBuzzSound".stop()

#func positive_rand(x: int, y: int) -> int:
	#return randi_range(y,x)

func _on_timer_rooster_timeout() -> void:
	if animatronic_rooster_camera == GlobalVars.camera_clicked:
		CamMovementStatic()
		await get_tree().create_timer(0.5).timeout	
		#positive_rand(20,15)
	animatronic_random_number = randi_range(0, 20)

	if animatronic_random_number > GlobalVars.animatronic_rooster_AI:
		return
	
	if animatronic_rooster_camera == GlobalVars.camera_clicked:
		#movement_sound()
		CamMovementStatic()
		await get_tree().create_timer(0.5).timeout	

	#if animatronic_rooster_camera == 7:
		#GlobalVars.rooster_door = true
		#GlobalVars.anger = randi_range(250,500)
		#$"../Office/DoorKillTimer".start()
		#if animatronic_rooster_camera == GlobalVars.camera_clicked:
			#CamMovementStatic()
			#await get_tree().create_timer(0.5).timeout	
	#elif animatronic_rooster_camera == 11:
		#GlobalVars.rooster_door = true
		#GlobalVars.anger = randi_range(250,500)
		#$"../Office/DoorKillTimer".start()
		#if animatronic_rooster_camera == GlobalVars.camera_clicked:
			#CamMovementStatic()
			#await get_tree().create_timer(0.5).timeout	

	match animatronic_rooster_camera:
		1:
			cam_1()
		2:
			cam_2()
		3:
			cam_3()
		4:
			cam_4()
		5:
			cam_5()
		6:
			cam_6()
		8:
			cam_8()
		9:
			cam_9()
		10:
			cam_10()
				
				
	if animatronic_rooster_camera == GlobalVars.camera_clicked:
		CamMovementStatic()
		await get_tree().create_timer(0.5).timeout	
	Cam_Change()



func cam_left_side():
	animatronic_rooster_camera = 5

func cam_right_side():
	animatronic_rooster_camera = 8

func cam_1():
	animatronic_rooster_camera += 1
	
func cam_2():
	animatronic_rooster_camera += randi_range(1,2)
	
func cam_3():
	animatronic_rooster_camera -= 1
	
func cam_4():
	var side_choose = randi_range(1, 2)
	if side_choose == 1:
		cam_left_side()
	else:
		cam_right_side()
	
func cam_5():
	$"../Office/WalkSound".play()
	animatronic_rooster_camera += randi_range(1,2)
	if animatronic_rooster_camera == 7:
		GlobalVars.anger = randi_range(250,500)
		$"../Office/DoorKillTimer".start()
	if GlobalVars.light_button_is_pressed == true and animatronic_rooster_camera == 7:
		$"../Office/AnimationPlayerOffice".play("animation_view_left_light_walk_in")
func cam_6():
	$"../Office/WalkSound".play()
	animatronic_rooster_door_var = randi_range(1,2)
	if animatronic_rooster_door_var == 1:
		animatronic_rooster_camera += 1
		GlobalVars.anger = randi_range(250,500)
		$"../Office/DoorKillTimer".start()
		if GlobalVars.light_button_is_pressed == true:
			$"../Office/AnimationPlayerOffice".play("animation_view_left_light_walk_in")
	elif animatronic_rooster_door_var == 2:
		animatronic_rooster_camera -= 1
	
func cam_7():
	if GlobalVars.light_button_is_pressed == true:
		$"../Office/AnimationPlayerOffice".play("animation_view_left_scared_away")
		$"../Office/RunningSound".play()
		#door_leave_sound()
		animatronic_rooster_door_var = randi_range(1,2)
		if animatronic_rooster_door_var == 1:
			animatronic_rooster_camera -= randi_range(1,2)
		elif animatronic_rooster_door_var == 2:
			animatronic_rooster_camera = 4
	elif GlobalVars.light_button_is_pressed == false:
		$"../Office/DoorKillTimer".stop()
		$"../Scream".play()
		$"../Office/LightButton".set_visible(false)
		$"../Office/UiPc".set_visible(false)
		$"../Office/Buttons".set_visible(false)
		$"../Office/AnimationPlayerOffice".play("animation_jumpscare_left")
		await get_tree().create_timer(0.7).timeout	
		animatronic_random_number = 0
		get_tree().change_scene_to_file("res://scenes/game_over_screen.tscn")

func cam_8():
	$"../Office/WalkSound".play()
	animatronic_rooster_camera += randi_range(1,3)
	if animatronic_rooster_camera == 11:
		GlobalVars.anger = randi_range(250,500)
		$"../Office/DoorKillTimer".start()
	if GlobalVars.light_button_is_pressed == true and animatronic_rooster_camera == 11:
		$"../Office/AnimationPlayerOffice".play("animation_view_right_light_walk_in")

func cam_9():
	$"../Office/WalkSound".play()
	animatronic_rooster_door_var = randi_range(1,4)
	if animatronic_rooster_door_var == 1:
		animatronic_rooster_camera += 1
	elif animatronic_rooster_door_var == 2 or 3:
		animatronic_rooster_camera += 2
		GlobalVars.anger = randi_range(250,500)
		$"../Office/DoorKillTimer".start()
		if GlobalVars.light_button_is_pressed == true:
			$"../Office/AnimationPlayerOffice".play("animation_view_right_light_walk_in")
	else:
		animatronic_rooster_camera	-= 4
	
func cam_10():
	$"../Office/WalkSound".play()
	animatronic_rooster_door_var = randi_range(1,2)
	if animatronic_rooster_door_var == 1:
		animatronic_rooster_camera -= 1
	elif animatronic_rooster_door_var == 2:
		animatronic_rooster_camera += 1
		GlobalVars.anger = randi_range(250,500)
		$"../Office/DoorKillTimer".start()
		if GlobalVars.light_button_is_pressed == true:
			$"../Office/AnimationPlayerOffice".play("animation_view_right_light_walk_in")
	
func cam_11():
	if GlobalVars.light_button_is_pressed == true:
		$"../Office/AnimationPlayerOffice".play("animation_view_right_scared_away")
		$"../Office/RunningSound".play()
		#door_leave_sound()
		animatronic_rooster_door_var = randi_range(1,2)
		if animatronic_rooster_door_var == 1:
			animatronic_rooster_camera -= randi_range(1,3)
		elif animatronic_rooster_door_var == 2:
			animatronic_rooster_camera = 4
	elif GlobalVars.light_button_is_pressed == false:
		$"../Office/DoorKillTimer".stop()
		$"../Scream".play()
		$"../Office/LightButton".set_visible(false)
		$"../Office/UiPc".set_visible(false)
		$"../Office/Buttons".set_visible(false)
		$"../Office/AnimationPlayerOffice".play("animation_jumpscare_right")
		await get_tree().create_timer(0.7).timeout	
		animatronic_random_number = 0
		get_tree().change_scene_to_file("res://scenes/game_over_screen.tscn")
	
		


func _on_light_button_button_down() -> void:
	
	$"../Office/FlashLightSound".play() 
	GlobalVars.light_button_is_pressed = true
	if(GlobalVars.light_button_is_pressed == true and animatronic_rooster_camera == 7 and GlobalVars.view_left == true):
		$"../Office/AnimationPlayerOffice".play("animation_view_left_animatronic")
		GlobalVars.anger += 20
	elif(GlobalVars.view_left == true):
		$"../Office/AnimationPlayerOffice".play("animation_view_left_light")
		GlobalVars.anger += 20
	elif(GlobalVars.light_button_is_pressed == true and animatronic_rooster_camera == 11 and GlobalVars.view_right == true):
		$"../Office/AnimationPlayerOffice".play("animation_view_right_animatronic")
	elif(GlobalVars.view_right == true):
		$"../Office/AnimationPlayerOffice".play("animation_view_right_light")
	else:
		pass


func _on_light_button_button_up() -> void:
	$"../Office/PowerUse".value -= 25
	$"../Office/FlashLightSound".stop()
	GlobalVars.light_button_is_pressed = false
	
	if(GlobalVars.view_left == true):
		$"../Office/AnimationPlayerOffice".play("animation_view_left_look")
	elif(GlobalVars.view_right == true):
		$"../Office/AnimationPlayerOffice".play("animation_view_right_look")
	else:
		pass
	
#func door_leave_sound():
	#var animatronic_rooster_leave_sound_number = randi_range(1,10)
	#match animatronic_rooster_leave_sound_number:
		#1:
			#$FiddlesticksOriginalDeath3.play()
		#2:
			#$FiddlesticksOriginalP4.play()
		#3:
			#$FiddlesticksOriginalDeath1.play()

#func movement_sound():
	#var animatronic_rooster_leave_sound_number = randi_range(1,20)
	#match animatronic_rooster_leave_sound_number:
		#1:
			#$FiddlesticksOriginalMove6.play()
		#2:
			#$FiddlesticksOriginalMoveLong3.play()
		#3:
			#$FiddlesticksOriginalJokeResponse.play()
		#4:
			#$FiddlesticksOriginalMoveFirst0.play()
		#5:
			#$FiddlesticksOriginalMoveFirst2.play()


func _on_door_kill_timer_timeout() -> void:
	print(GlobalVars.anger)
	if(GlobalVars.light_button_is_pressed == true and GlobalVars.rooster_door == true):
		GlobalVars.anger -= 40	
	else:
		GlobalVars.anger += 10	
	
	if(GlobalVars.anger >= 750 and animatronic_rooster_camera == 11):
		cam_11()	
	elif(GlobalVars.anger >= 750 and animatronic_rooster_camera == 7):
		cam_7()	
		
	if(GlobalVars.light_button_is_pressed == true):
		if(GlobalVars.anger <= 250 and animatronic_rooster_camera == 11):
			$"../Office/AnimationPlayerOffice".play("animation_view_right_twithing")
		elif(GlobalVars.anger <= 250 and animatronic_rooster_camera == 7):
			$"../Office/AnimationPlayerOffice".play("animation_view_right_twithing")
			
	if(GlobalVars.anger <= 0 ):
		match (animatronic_rooster_camera):
			7:
					GlobalVars.rooster_door = false
					cam_7()	
					GlobalVars.anger = 1000
					$"../TimerRooster".wait_time = 5
					$"../Office/DoorKillTimer".stop()
			11:
					GlobalVars.rooster_door = false
					cam_11()	
					GlobalVars.anger = 1000
					$"../TimerRooster".wait_time = 5
					$"../Office/DoorKillTimer".stop()
