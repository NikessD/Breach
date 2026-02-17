extends Control

var loader: ResourceLoader
var progress: = 0.0




func _process(delta):
	var status = ResourceLoader.load_threaded_get_status("res://scenes/game.tscn")

	if status == ResourceLoader.THREAD_LOAD_LOADED:
		var packed_scene = ResourceLoader.load_threaded_get("res://scenes/game.tscn")
		get_tree().change_scene_to_packed(packed_scene)



func _ready() -> void:
	var err = GlobalVars.config.load("user://save.cfg")	
	if err != OK:
		GlobalVars.config = ConfigFile.new()
		GlobalVars.config.set_value("night number", "night_number", 1)
		GlobalVars.config.save("user://save.cfg")
	else:
		GlobalVars.night_number = GlobalVars.config.get_value("night number", "night_number", GlobalVars.night_number)
		if GlobalVars.night_number == null:
			GlobalVars.config.set_value("night number", "night_number", 1)
			$Menu/MenuButtons/Play.text = "NIGHT " + str(GlobalVars.night_number)
		elif GlobalVars.night_number != 1:
			$Menu/MenuButtons/Play.text = "NIGHT " + str(GlobalVars.night_number)

	#match GlobalVars.night:	
		#1:
			#$BackGround.play("Night1")
		#2:
			#$BackGround.play("Night2")
		#3:
			#$BackGround.play("Night3")
		#4:
			#$BackGround.play("Night4")
		#5:
			#$BackGround.play("Night5")
		#6:
			#$BackGround.play("Night6")
		
	
func _on_play_pressed() -> void:
	ResourceLoader.load_threaded_request("res://scenes/game.tscn")
	$ColorRect2.self_modulate.a = 0
	$StaticTimer.stop()
	$MenuTheme.stop()
	$Menu/Background/MenuStatic.stop()
	$StartButtonSound.play()
	$LoadingScreen/NightNumber.text = "NIGHT " + str(GlobalVars.night_number)
	$Menu.set_visible(false)
	$LoadingScreen.set_visible(true)
	$ColorRect2.set_visible(true)
	for n in range(100):
		$ColorRect2.self_modulate.a += 0.1
		$Static.self_modulate.a += 0.1
		await get_tree().process_frame
	await get_tree().create_timer(3).timeout

	

	
func _on_options_pressed() -> void:

	$Menu/ClickSound.play()
	show_and_hide($Settings, $Menu)
	
func show_and_hide(first, second):
	first.show()
	second.hide()

func _on_quit_pressed() -> void:
	$Menu/ClickSound.play()
	get_tree().quit()


func _on_play_mouse_entered() -> void:
	$Menu/HoverSound.play()
	$Menu/MenuButtons/ButtonBackgoundSprite.set_position(Vector2(132, 143))


func _on_options_mouse_entered() -> void:
	$Menu/HoverSound.play()
	$Menu/MenuButtons/ButtonBackgoundSprite.set_position(Vector2(125, 207))


func _on_quit_mouse_entered() -> void:
	$Menu/HoverSound.play()
	$Menu/MenuButtons/ButtonBackgoundSprite.set_position(Vector2(134, 267))

func _on_exit_pressed() -> void:
	$StaticTimer.start()
	$Menu/ClickSound.play()
	show_and_hide($Menu, $Settings)
	$ColorRect2.set_visible(false)

func volume(bus_index, value):
	AudioServer.set_bus_volume_db(bus_index, value)

func _on_master_volume_value_changed(value: float) -> void:
		value = GlobalVars.masterVOL
		volume(0,linear_to_db(value))
		GlobalVars.config.set_value("options", "masterVOL", GlobalVars.masterVOL)
		GlobalVars.config.save("res://save.cfg")
	

func _on_vfx_value_changed(value: float) -> void:
	var err = GlobalVars.config.load("res://save.cfg")	
	if err != OK:
		GlobalVars.config = ConfigFile.new()
		GlobalVars.config.set_value("options", "vfxVOL", GlobalVars.vfxVOL)
		GlobalVars.config.save("res://save.cfg")
	else:
		GlobalVars.vfxVOL = value
		volume(2,linear_to_db(value))
		GlobalVars.config.set_value("options", "vfxVOL", GlobalVars.vfxVOL)
		GlobalVars.config.save("res://save.cfg")
		
func _on_ambience_value_changed(value: float) -> void:
	var err = GlobalVars.config.load("res://save.cfg")	
	if err != OK:
		GlobalVars.config = ConfigFile.new()
		GlobalVars.config.set_value("options", "ambienceVOL", GlobalVars.ambienceVOL)
		GlobalVars.config.save("res://save.cfg")
	else:
		GlobalVars.ambienceVOL = value
		volume(1,linear_to_db(value))
		GlobalVars.config.set_value("options", "ambienceVOL", GlobalVars.ambienceVOL)


func _on_exit_mouse_entered() -> void:
	$Menu/HoverSound.play()


func _on_back_ground_change_timer_timeout() -> void:
	var random = randi_range(0,10)
	if random == 0:
		$BackGround.frame = 0
	elif random == 1:
		for x in range(5):
			$BackGround.frame = 1
			await get_tree().create_timer(0.2).timeout
			$BackGround.frame = 0
	elif random == 2:
		for x in range(5):
			$BackGround.frame = 2
			await get_tree().create_timer(0.2).timeout
			$BackGround.frame = 0
	$BackGroundChange_Timer.wait_time = randf_range(0.1, 0.4)
	$BackGroundChange_Timer.start()


func _on_static_timer_timeout() -> void:
	$Static.self_modulate.a = randf_range(0.4,0.6)
	$BackGround.self_modulate.a = randf_range(0.8,1)


func _on_settings_pressed() -> void:
	$Static.self_modulate.a = 1000
	$StaticTimer.stop()
	show_and_hide($Settings, $Menu)
	$Menu/ClickSound.play()
	$ColorRect2.set_visible(true)

	
func _on_settings_mouse_entered() -> void:
	$Menu/HoverSound.play()
	$Menu/MenuButtons/ButtonBackgoundSprite.set_position(Vector2(125, 207))
