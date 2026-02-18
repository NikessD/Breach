extends Node

var tutorial_door_view_first: bool = false
var tutorial_camera_view_first: bool = false
var ominious_sound_number: int = 0
var power: float = 100
var previous_cam: int = 0

@onready var ricky: Animatronic = $Ricky
@onready var ardent: Control  = $Ardent
@onready var node_camera_tutorial: Control = $Tutorial/CamFeed
@onready var node_flashlight_tutorial: Control = $Tutorial/SideView
@onready var node_viewbuttons: Control = $ViewMoveButtons
@onready var node_office_animationplayer: AnimatedSprite2D = $AnimationPlayerOffice
@onready var sprite_camerafeed: AnimatedSprite2D = $UiPc/CamFeed/CameraFeed
@onready var sprite_camera_static: AnimatedSprite2D = $UiPc/CamFeed/CameraStatic
@onready var button_view_left: Button = $ViewMoveButtons/ButtonLeftSide
@onready var button_view_right: Button = $ViewMoveButtons/ButtonRightSide
@onready var sprite_lightbutton: TextureButton = $LightButton
@onready var label_hour: Label = $UiPc/GameHour
@onready var label_power: Label = $UiPc/Power


func _ready() -> void:
	node_camera_tutorial.set_visible(false)
	node_flashlight_tutorial.set_visible(false)
	node_office_animationplayer.play("animation_view_front")
	GlobalVars.view_front = true
	
	if GlobalVars.night_number == 1:
		node_viewbuttons.set_visible(false)
		node_camera_tutorial.set_visible(true)
		await get_tree().create_timer(20).timeout
		await get_tree().process_frame
		node_camera_tutorial.set_visible(false)
		button_anim_tutorial()	


func _process(delta: float) -> void:
	if GlobalVars.light_button_is_pressed == true:
		power -= 0.015
	if power > 0:
		power -= 0.003

	power = snapped(power,0.001) 
	label_power.text = str(power) + " POWER"
	if power <= 0 and power < 0:
		blackout()


func button_anim_tutorial():
	for x in range(5):
		node_viewbuttons.set_visible(false)
		await get_tree().create_timer(0.15).timeout
		node_viewbuttons.set_visible(true)
		await get_tree().create_timer(0.15).timeout


func camera_static():
	sprite_camera_static.self_modulate.a = (10)
	$CamBuzzSound.play()
	await get_tree().create_timer(0.2).timeout	
	sprite_camera_static.self_modulate.a = (0.2)
	$CamBuzzSound.stop()


func _on_button_right_side_mouse_entered() -> void:
	if GlobalVars.night_number == 1 and tutorial_camera_view_first:
		tutorial_camera_view_first = 1
		node_camera_tutorial.set_visible(false)

	if GlobalVars.view_front == true:
			GlobalVars.view_right = true
			GlobalVars.view_front = false
			node_office_animationplayer.play("animation_view_right")
			$UiPc.set_visible(false)
			node_viewbuttons.set_visible(false)
			await get_tree().create_timer(0.3).timeout
			node_viewbuttons.set_visible(true)
			button_view_right.set_visible(false)
			sprite_lightbutton.set_visible(true)
	elif GlobalVars.view_left == true:
		GlobalVars.view_front = true
		GlobalVars.view_left = false
		node_office_animationplayer.play_backwards("animation_view_left")
		sprite_lightbutton.set_visible(false)
		node_viewbuttons.set_visible(false)
		await get_tree().create_timer(0.25).timeout
		button_view_left.set_visible(true)
		node_viewbuttons.set_visible(true)
		$UiPc.set_visible(true)

	if GlobalVars.night_number == 1 and tutorial_door_view_first == false:
		dvere_tutorial()


func _on_button_left_side_mouse_entered(): 
	if GlobalVars.night_number == 1 and tutorial_camera_view_first:
		tutorial_camera_view_first = 1
		node_camera_tutorial.set_visible(false)
		
	if GlobalVars.view_front == true:
		GlobalVars.view_left = true
		GlobalVars.view_front = false
		node_office_animationplayer.play("animation_view_left")
		$UiPc.set_visible(false)
		node_viewbuttons.set_visible(false)
		await get_tree().create_timer(0.3).timeout
		node_viewbuttons.set_visible(true)
		button_view_left.set_visible(false)
		sprite_lightbutton.set_visible(true)
	elif GlobalVars.view_right == true:
		GlobalVars.view_front = true
		GlobalVars.view_right = false
		node_office_animationplayer.play_backwards("animation_view_right")
		sprite_lightbutton.set_visible(false)
		node_viewbuttons.set_visible(false)
		await get_tree().create_timer(0.25).timeout
		button_view_right.set_visible(true)
		node_viewbuttons.set_visible(true)
		$UiPc.set_visible(true)

	if GlobalVars.night_number == 1 and tutorial_door_view_first == false:
		dvere_tutorial()


func _on_timer_hour_timeout() -> void:
	GlobalVars.hour += 1
	label_hour.text = str(GlobalVars.hour) + ":00"
	
	if GlobalVars.hour == 6:
		get_tree().change_scene_to_file("res://scenes/night_win_screen.tscn")


func dvere_tutorial():
	tutorial_door_view_first = 1
	node_flashlight_tutorial.set_visible(true)
	await get_tree().create_timer(7).timeout
	node_flashlight_tutorial.set_visible(false)


func _on_light_button_button_down() -> void:
	$"../Office/FlashLightSound".play() 
	GlobalVars.light_button_is_pressed = true
	
	if (
			GlobalVars.light_button_is_pressed 
			and ricky.camera == 7 
			and GlobalVars.view_left
	):
		node_office_animationplayer.play("animation_view_left_animatronic")
		ricky.anger += 20
	elif GlobalVars.view_left:
		node_office_animationplayer.play("animation_view_left_light")
		ricky.anger += 20
	elif (
			GlobalVars.light_button_is_pressed 
			and ricky.camera == 11 
			and GlobalVars.view_right
	):
		node_office_animationplayer.play("animation_view_right_animatronic")
	elif GlobalVars.view_right:
		node_office_animationplayer.play("animation_view_right_light")


func _on_light_button_button_up() -> void:
	$"../Office/FlashLightSound".stop()
	GlobalVars.light_button_is_pressed = false
	
	if GlobalVars.view_left:
		node_office_animationplayer.play("animation_view_left_look")
	elif GlobalVars.view_right:
		node_office_animationplayer.play("animation_view_right_look")
	else:
		pass


func camera_change():
	$UiPc/Cameras.text =  "CAM " + str(GlobalVars.camera_ID) 
	if (
			GlobalVars.camera_clicked == ardent.camera 
			and GlobalVars.view_front
			and not GlobalVars.blackout
	):
		ardent.anger_timer.start()
		ardent.anger = randi_range(100,200)
		$UiPc/CamFeed/Ardent.set_visible(true)
	elif (
			GlobalVars.camera_clicked != ardent.camera 
			and GlobalVars.view_front
			and not GlobalVars.blackout
	):
		ardent.anger_timer.stop()
		$UiPc/CamFeed/Ardent.set_visible(false)

	if GlobalVars.camera_clicked == ricky.camera:
		match GlobalVars.camera_clicked:
				1:
					sprite_camerafeed.play("Cam1Animatronic")
				2:
					sprite_camerafeed.play("Cam2Animatronic")
				3:
					sprite_camerafeed.play("Cam3Animatronic")
				4:
					sprite_camerafeed.play("Cam4Animatronic")
				5:
					sprite_camerafeed.play("Cam5Animatronic")
				6:
					sprite_camerafeed.play("Cam6Animatronic")
				8:
					sprite_camerafeed.play("Cam7Animatronic")
				9:
					sprite_camerafeed.play("Cam8Animatronic")
				10:
					sprite_camera_static.self_modulate.a = (10)

	else:
		match GlobalVars.camera_clicked:
			1:
				sprite_camerafeed.play("Cam1Nothing")
			2:
				sprite_camerafeed.play("Cam2Nothing")
			3:
				sprite_camerafeed.play("Cam3Nothing")
			4:
				sprite_camerafeed.play("Cam4Nothing")
			5:
				sprite_camerafeed.play("Cam5Nothing")
			6:
				sprite_camerafeed.play("Cam6Nothing")
			8:
				sprite_camerafeed.play("Cam7Nothing")
			9:
				sprite_camerafeed.play("Cam8Nothing")
			10:
				sprite_camera_static.self_modulate.a = (10)

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
	node_office_animationplayer.play("anim_blackout")
	ardent.move_timer.stop()
	ricky.move_timer.stop()
	GlobalVars.blackout = true
	$UiPc.set_visible(false)
	$Buttons.set_visible(false)
	sprite_lightbutton.set_visible(false)
	$PowerDownSound.play() 
	if ardent.killer:
		ardent.kill()
	else:
		ricky.kill()


func cam_button_clicked():
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
