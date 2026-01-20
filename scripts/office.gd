extends Node

# player var
var door_view_first = 0
var cam_view_first = 0
# Animatronic var

@onready var ricky = $Ricky
@onready var ardent = $Ardent
# player var
var power: float = 100


# sound var
var ominious_sound_number = 0

var previous_cam: int = 0



func _ready() -> void:
	

	$Tutorial/camfed.set_visible(false)
	$Tutorial/sideview.set_visible(false)
	$AnimationPlayerOffice.play("animation_view_front")
	GlobalVars.view_front = true
	if GlobalVars.night_number == 1:
		$Buttons.set_visible(false)
		$Tutorial/camfed.set_visible(true)
		await get_tree().create_timer(20).timeout
		await get_tree().process_frame
		$Tutorial/camfed.set_visible(false)
		button_anim_tutorial()	




func button_anim_tutorial():
		$Buttons.set_visible(true)
		await get_tree().create_timer(0.3).timeout
		$Buttons.set_visible(false)
		await get_tree().create_timer(0.3).timeout
		$Buttons.set_visible(true)
		await get_tree().create_timer(0.3).timeout
		$Buttons.set_visible(false)
		await get_tree().create_timer(0.3).timeout
		$Buttons.set_visible(true)		
		
func _process(delta: float) -> void:
	if GlobalVars.light_button_is_pressed == true:
		power -= 0.015
	if power > 0:
		power -= 0.003
	power = snapped(power,0.001) 
	$UiPc/Power.text = str(power) + " POWER"
	if power <= 0 and power < 0:
		linegring_death()


	
	ominious_sound_number = randi_range(0,100000)
	match ominious_sound_number:
		1:
			$OminiousSound1.play()
		2:
			$OminiousSound2.play()
		3:
			$OminiousSound3.play()




func camera_static():
	$UiPc/CamFeed/CameraStatic.self_modulate.a = (10)
	$CamBuzzSound.play()
	await get_tree().create_timer(0.3).timeout	
	$UiPc/CamFeed/CameraStatic.self_modulate.a = (0.2)
	$CamBuzzSound.stop()

func linegring_death():
	GlobalVars.blackout = true
	$UiPc.set_visible(false)
	$Buttons.set_visible(false)
	$PowerDownSound.play()
	@warning_ignore("integer_division")
	await get_tree().create_timer(20/GlobalVars.night_number).timeout
	get_tree().change_scene_to_file("res://scenes/game_over_screen.tscn")

# Pravý pohyb hráče
func _on_button_right_side_mouse_entered() -> void:
	if GlobalVars.night_number == 1 and cam_view_first == 1:
		cam_view_first = 1
		$Tutorial/camfed.set_visible(false)
	if GlobalVars.view_front == true:
			GlobalVars.view_right = true
			GlobalVars.view_front = false
			$AnimationPlayerOffice.play("animation_view_right")
			$UiPc.set_visible(false)
			$Buttons.set_visible(false)
			await get_tree().create_timer(0.3).timeout
			$Buttons.set_visible(true)
			$Buttons/ButtonRightSide.set_visible(false)
			$LightButton.set_visible(true)

	elif GlobalVars.view_left == true:
		GlobalVars.view_front = true
		GlobalVars.view_left = false
		$AnimationPlayerOffice.play_backwards("animation_view_left")
		$LightButton.set_visible(false)
		$Buttons.set_visible(false)
		await get_tree().create_timer(0.25).timeout
		$Buttons/ButtonLeftSide.set_visible(true)
		$Buttons.set_visible(true)
		$UiPc.set_visible(true)

	if GlobalVars.night_number == 1 and door_view_first == 0:
		dvere_tutorial()
		
# Levý pohyb hráče
func _on_button_left_side_mouse_entered(): 
	if GlobalVars.night_number == 1 and cam_view_first == 1:
		cam_view_first = 1
		$Tutorial/camfed.set_visible(false)
		
	if GlobalVars.view_front == true:
		GlobalVars.view_left = true
		GlobalVars.view_front = false
		$AnimationPlayerOffice.play("animation_view_left")
		$UiPc.set_visible(false)
		$Buttons.set_visible(false)
		await get_tree().create_timer(0.3).timeout
		$Buttons.set_visible(true)
		$Buttons/ButtonLeftSide.set_visible(false)
		$LightButton.set_visible(true)

		
	elif GlobalVars.view_right == true:
		GlobalVars.view_front = true
		GlobalVars.view_right = false
		$AnimationPlayerOffice.play_backwards("animation_view_right")
		$LightButton.set_visible(false)
		$Buttons.set_visible(false)
		await get_tree().create_timer(0.25).timeout
		$Buttons/ButtonRightSide.set_visible(true)
		$Buttons.set_visible(true)
		$UiPc.set_visible(true)

	if GlobalVars.night_number == 1 and door_view_first == 0:
		dvere_tutorial()



#Hodiny
func _on_timer_hour_timeout() -> void:
	GlobalVars.hour += 1
	$UiPc/GameHour.text = str(GlobalVars.hour) + " AM"
	if GlobalVars.hour == 6:
		get_tree().change_scene_to_file("res://scenes/night_win_screen.tscn")
	
	
func dvere_tutorial():
	door_view_first = 1
	$Tutorial/sideview.set_visible(true)
	await get_tree().create_timer(7).timeout
	$Tutorial/sideview.set_visible(false)
		
	

func _on_light_button_button_down() -> void:
	$"../Office/FlashLightSound".play() 
	GlobalVars.light_button_is_pressed = true
	if(GlobalVars.light_button_is_pressed == true and ricky.camera == 7 and GlobalVars.view_left == true):
		$"../Office/AnimationPlayerOffice".play("animation_view_left_animatronic")
		ricky.anger += 20
	elif(GlobalVars.view_left == true):
		$"../Office/AnimationPlayerOffice".play("animation_view_left_light")
		ricky.anger += 20
	elif(GlobalVars.light_button_is_pressed == true and ricky.camera == 11 and GlobalVars.view_right == true):
		$"../Office/AnimationPlayerOffice".play("animation_view_right_animatronic")
	elif(GlobalVars.view_right == true):
		$"../Office/AnimationPlayerOffice".play("animation_view_right_light")
	else:
		pass

func _on_light_button_button_up() -> void:
	$"../Office/FlashLightSound".stop()
	GlobalVars.light_button_is_pressed = false
	
	if(GlobalVars.view_left == true):
		$"../Office/AnimationPlayerOffice".play("animation_view_left_look")
	elif(GlobalVars.view_right == true):
		$"../Office/AnimationPlayerOffice".play("animation_view_right_look")
	else:
		pass
		
		
		
func camera_change():

	$UiPc/Cameras.text =  "CAM " + str(GlobalVars.camera_ID) 
	
	if (GlobalVars.camera_clicked == ardent.camera and GlobalVars.view_front == true and GlobalVars.blackout == false):
		ardent.anger_timer.start()
		ardent.anger = randi_range(100,200)
		$UiPc/CamFeed/Ardent.set_visible(true)
	elif (GlobalVars.camera_clicked != ardent.camera and GlobalVars.view_front == true and GlobalVars.blackout == false):
		ardent.anger_timer.stop()
		$UiPc/CamFeed/Ardent.set_visible(false)
	if (GlobalVars.camera_clicked == ricky.camera):
		match GlobalVars.camera_clicked:
				1:
					$UiPc/CamFeed/CameraFeed.play("Cam1Animatronic")
				2:
					$UiPc/CamFeed/CameraFeed.play("Cam2Animatronic")
				3:
					$UiPc/CamFeed/CameraFeed.play("Cam3Animatronic")
				4:
					$UiPc/CamFeed/CameraFeed.play("Cam4Animatronic")
				5:
					$UiPc/CamFeed/CameraFeed.play("Cam5Animatronic")
				6:
					$UiPc/CamFeed/CameraFeed.play("Cam6Animatronic")
				8:
					$UiPc/CamFeed/CameraFeed.play("Cam7Animatronic")
				9:
					$UiPc/CamFeed/CameraFeed.play("Cam8Animatronic")
				10:
					$UiPc/CamFeed/CameraFeed.play("Cam9")
				
	else:
		match GlobalVars.camera_clicked:
			1:
				$UiPc/CamFeed/CameraFeed.play("Cam1Nothing")
			2:
				$UiPc/CamFeed/CameraFeed.play("Cam2Nothing")
			3:
				$UiPc/CamFeed/CameraFeed.play("Cam3Nothing")
			4:
				$UiPc/CamFeed/CameraFeed.play("Cam4Nothing")
			5:
				$UiPc/CamFeed/CameraFeed.play("Cam5Nothing")
			6:
				$UiPc/CamFeed/CameraFeed.play("Cam6Nothing")
			8:
				$UiPc/CamFeed/CameraFeed.play("Cam7Nothing")
			9:
				$UiPc/CamFeed/CameraFeed.play("Cam8Nothing")
			10:
				$UiPc/CamFeed/CameraFeed.play("Cam9")
				
	if GlobalVars.camera_clicked == 10:
		$"../Office/CamBuzzSound".play()
	else:
		$"../Office/CamBuzzSound".stop()

	

	 

	

	
func _on_cam_8_button_pressed() -> void:

	camera_change()
	$CamSelected.play()
	camera_static() 
	
func _on_cam_9_button_pressed() -> void:
	GlobalVars.camera_clicked = 10
	GlobalVars.camera_ID = 9
	camera_change()
	$CamSelected.play() 
	camera_static()


func blackout():
	$AnimationPlayerOffice.play("anim_blackout")
	ardent.move_timer.stop()
	ricky.move_timer.stop()
	GlobalVars.blackout = true
	$UiPc.set_visible(false)
	$Buttons.set_visible(false)
	$LightButton.set_visible(false)
	$PowerDownSound.play() 
	if (ardent.killer == true):
		ardent.kill()
	else:
		ricky.kill()


func begining_set_ai():
	match GlobalVars.night_number:
		1:
			ardent.ai = 0
			ricky.ai = 3
		2:
			ardent.ai = 1
			ricky.ai = 5
		3:
			ardent.ai = 3
			ricky.ai = 7
		4:
			ardent.ai = 4
			ricky.ai = 9
		5:
			ardent.ai = 6
			ricky.ai = 12
		6:
			ardent.ai = 20
			ricky.ai = 20
		null:
			ardent.ai = 20
			ricky.ai = 20


func cam_button_clicked():
	print("př " + str(previous_cam))
	print("ted " + str(GlobalVars.camera_ID))
	if previous_cam != GlobalVars.camera_ID:
		match previous_cam:
			1:
				$UiPc/StageButton.set_pressed_no_signal(false)
			2:
				$UiPc/DinningHallButton.set_pressed_no_signal(false)
			3:
				$UiPc/PASButton.set_pressed_no_signal(false)
			4:
				$UiPc/HallwayButton.set_pressed_no_signal(false)
			5:
				$UiPc/HallwayLeftButton.set_pressed_no_signal(false)
			6:
				$UiPc/DoorLeftCornerButton.set_pressed_no_signal(false)
			7:
				$UiPc/HallwayRightButton.set_pressed_no_signal(false)
			8:
				$UiPc/DoorRightCornerButton.set_pressed_no_signal(false)
			9:
				$UiPc/BackroomButton.set_pressed_no_signal(false)
	match GlobalVars.camera_ID:
		1:
			$UiPc/StageButton.set_pressed_no_signal(true)
		2:
			$UiPc/DinningHallButton.set_pressed_no_signal(true)
		3:
			$UiPc/PASButton.set_pressed_no_signal(true)
		4:
			$UiPc/HallwayButton.set_pressed_no_signal(true)
		5:
			$UiPc/HallwayLeftButton.set_pressed_no_signal(true)
		6:
			$UiPc/DoorLeftCornerButton.set_pressed_no_signal(true)
		7:
			$UiPc/HallwayRightButton.set_pressed_no_signal(true)
		8:
			$UiPc/DoorRightCornerButton.set_pressed_no_signal(true)
		9:
			$UiPc/BackroomButton.set_pressed_no_signal(true)

	camera_change()
	$CamSelected.play() 
	camera_static()


func _on_stage_button_pressed() -> void:
	previous_cam = GlobalVars.camera_ID
	GlobalVars.camera_clicked = 1
	GlobalVars.camera_ID = 1
	cam_button_clicked()


func _on_dinning_hall_button_pressed() -> void:
	previous_cam = GlobalVars.camera_ID
	GlobalVars.camera_clicked = 2
	GlobalVars.camera_ID = 2
	cam_button_clicked()


func _on_pas_button_pressed() -> void:
	previous_cam = GlobalVars.camera_ID
	GlobalVars.camera_clicked = 3
	GlobalVars.camera_ID = 3
	cam_button_clicked()


func _on_hallway_button_pressed() -> void:
	previous_cam = GlobalVars.camera_ID
	GlobalVars.camera_clicked = 4
	GlobalVars.camera_ID = 4
	cam_button_clicked()


func _on_hallway_left_button_pressed() -> void:
	previous_cam = GlobalVars.camera_ID
	GlobalVars.camera_clicked = 5
	GlobalVars.camera_ID = 5
	cam_button_clicked()


func _on_hallway_right_button_pressed() -> void:
	previous_cam = GlobalVars.camera_ID
	GlobalVars.camera_clicked = 8
	GlobalVars.camera_ID = 7
	cam_button_clicked()
	


func _on_door_left_corner_button_pressed() -> void:
	previous_cam = GlobalVars.camera_ID
	GlobalVars.camera_clicked = 6
	GlobalVars.camera_ID = 6
	cam_button_clicked()


func _on_door_right_corner_button_pressed() -> void:
	previous_cam = GlobalVars.camera_ID	
	GlobalVars.camera_clicked = 9
	GlobalVars.camera_ID = 8
	cam_button_clicked()


func _on_backroom_button_pressed() -> void:
	previous_cam = GlobalVars.camera_ID	
	GlobalVars.camera_clicked = 10
	GlobalVars.camera_ID = 9
	cam_button_clicked()
