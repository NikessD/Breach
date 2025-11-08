extends Control

# player var
var head_position = "stred"
var door_view_first = 0
var cam_view_first = 0

# Animatronic var
var hour = 0
var game_over = 0

# player var
var power = 100
var power_down_check = 0

# sound var
var ominious_sound_number = 0

# GoldenS var

var GoldenS_random_number = 1
var GoldenS_camera = 0
var GoldenS_timer = 0
var GoldenS_anger = 0


func _ready() -> void:
	$Tutorial/camfed.set_visible(false)
	$Tutorial/sideview.set_visible(false)
	$PowerUse.value = 10
	$AnimationPlayerOffice.play("animation_view_front")
	GlobalVars.view_front = true
	if GlobalVars.night == 1:
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
	if hour == 6:
		get_tree().change_scene_to_file("res://scenes/night_win_screen.tscn")
	if GlobalVars.light_button_is_pressed == true:
		power -= 0.015
	if power > 0:
		power -= 0.003
	power = snapped(power,0.001) 
	$UiPc/Power.text = str(power) + " POWER"
	
	if power <= 0 and power_down_check == 0:
		power_down_check = 1
		$UiPc.set_visible(false)
		$Buttons.set_visible(false)
		$PowerDownSound.play()
		await get_tree().create_timer(20/GlobalVars.night).timeout
		get_tree().change_scene_to_file("res://scenes/game_over_screen.tscn")
		

	ominious_sound_number = randi_range(0,100000)
	match ominious_sound_number:
		1:
			$OminiousSound1.play()
		2:
			$OminiousSound2.play()
		3:
			$OminiousSound3.play()

	if GoldenS_anger >= 299:
		$UiPc.set_visible(false)
		$Buttons.set_visible(false)
		$AnimationPlayerOffice.play("animation_golden_s_death")
		$"../Scream".play()
		await get_tree().create_timer(3).timeout
		get_tree().change_scene_to_file("res://scenes/game_over_screen.tscn")
	if GoldenS_camera == GlobalVars.camera_clicked and GlobalVars.view_front == true:
		$UiPc/CamFeed/GoldenRupraveno.set_visible(true)
		GoldenS_anger = min(GoldenS_anger + 100 * delta, 300)
	else:
		GoldenS_anger = 0
		$UiPc/CamFeed/GoldenRupraveno.set_visible(false)


# Pravý pohyb hráče
func _on_button_right_side_mouse_entered() -> void:
	if GlobalVars.night == 1 and cam_view_first == 1:
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

	if GlobalVars.night == 1 and door_view_first == 0:
		dvere_tutorial()
		
# Levý pohyb hráče
func _on_button_left_side_mouse_entered(): 
	if GlobalVars.night == 1 and cam_view_first == 1:
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

	if GlobalVars.night == 1 and door_view_first == 0:
		dvere_tutorial()



#Hodiny
func _on_timer_hour_timeout() -> void:
	hour += 1
	$UiPc/GameHour.text = str(hour) + " AM"
	
func dvere_tutorial():
	door_view_first = 1
	$Tutorial/sideview.set_visible(true)
	await get_tree().create_timer(7).timeout
	$Tutorial/sideview.set_visible(false)
		
		
func _on_golden_s_timer_timeout() -> void:
	GoldenS_camera = 0
	GoldenS_random_number = randi_range(0, 20)
	if GoldenS_random_number <= GlobalVars.golden_s_AI and GlobalVars.golden_s_AI > 0:
		GoldenS_camera = randi_range(0, 10)
		GoldenS_timer = randi_range(80, 120) / GlobalVars.golden_s_AI
		await get_tree().create_timer(GoldenS_timer).timeout

	else:
		pass



func _on_cam_1_button_pressed() -> void:
	GlobalVars.camera_clicked = 1
	GlobalVars.camera_ID = 1
	$CamSelected.play()
	get_node("../RoosterAi").Cam_Change()

func _on_cam_2_button_pressed() -> void:
	GlobalVars.camera_clicked = 2
	GlobalVars.camera_ID = 2
	$CamSelected.play()
	get_node("../RoosterAi").Cam_Change()

func _on_cam_3_button_pressed() -> void:
	GlobalVars.camera_clicked = 3
	GlobalVars.camera_ID = 3
	$CamSelected.play() 
	get_node("../RoosterAi").Cam_Change()	

func _on_cam_4_button_pressed() -> void:
	GlobalVars.camera_clicked = 4
	GlobalVars.camera_ID = 4
	$CamSelected.play() 
	get_node("../RoosterAi").Cam_Change()

func _on_cam_5_button_pressed() -> void:
	GlobalVars.camera_clicked = 5
	GlobalVars.camera_ID = 5
	$CamSelected.play() 
	get_node("../RoosterAi").Cam_Change()
	
func _on_cam_6_button_pressed() -> void:
	GlobalVars.camera_clicked = 6
	GlobalVars.camera_ID = 6
	$CamSelected.play() 
	get_node("../RoosterAi").Cam_Change()
	
func _on_cam_7_button_pressed() -> void:
	GlobalVars.camera_clicked = 8
	GlobalVars.camera_ID = 7
	$CamSelected.play() 
	get_node("../RoosterAi").Cam_Change()
		
func _on_cam_8_button_pressed() -> void:
	GlobalVars.camera_clicked = 9
	GlobalVars.camera_ID = 8
	$CamSelected.play() 
	get_node("../RoosterAi").Cam_Change()
func _on_cam_9_button_pressed() -> void:
	GlobalVars.camera_clicked = 10
	GlobalVars.camera_ID = 9
	$CamSelected.play() 
	get_node("../RoosterAi").Cam_Change()


func _on_ambient_sounds_timer_timeout() -> void:
	$"../AmbientSounds/Creepyambience2".play()
	$"../AmbientSounds/Creepyambience1".play()
	$"../AmbientSounds/Creepyambience2".volume_db = -1000000000
	$"../AmbientSounds/Creepyambience1".volume_db = -1000000000
	var random_ambient = randi_range(1,10)
	print(random_ambient)
	if random_ambient == 8:
		$"../AmbientSounds/Creepyambience1".volume_db = -51
		$"../AmbientSounds/Creepyambience2".volume_db = -1000000000
	elif random_ambient == 1:
		$"../AmbientSounds/Creepyambience1".volume_db = -1000000000
		$"../AmbientSounds/Creepyambience2".volume_db = -27

	
