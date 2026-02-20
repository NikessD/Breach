extends Control

var loader: ResourceLoader
var progress: = 0.0


@onready var background: AnimatedSprite2D = $BackGround
@onready var slider_volume_master: HSlider = $Settings/BackColor/MarginContainer/VBoxContainer/volume_slider
@onready var slider_volume_vfx: HSlider = $Settings/BackColor/MarginContainer/VBoxContainer/volume_slider2


func _ready() -> void:
	Saveload._load()
	print("----------------------")
	print(str(GlobalVars.volume[0]))
	print(str(GlobalVars.volume[1]))
	GlobalVars.night_number = Saveload.contents_to_save.night_number
	GlobalVars.volume[1] = Saveload.contents_to_save.vfx_volume
	GlobalVars.volume[0] = Saveload.contents_to_save.master_volume
	print("----------------------")
	print(str(GlobalVars.volume[0]))
	print(str(GlobalVars.volume[1]))
	slider_volume_master._set_volume()
	slider_volume_vfx._set_volume()
	$Menu/MenuButtons/Play.text = "NIGHT " + str(GlobalVars.night_number)
	$StaticTimer.stop()
	$Static.self_modulate.a = 10
	var tween = create_tween()
	tween.parallel().tween_property($Static, "self_modulate:a", 0.0, 0.5)
	await get_tree().create_timer(0.5).timeout
	$StaticTimer.start()
	

func _process(delta):
	var status = ResourceLoader.load_threaded_get_status("res://scenes/game.tscn")

	if status == ResourceLoader.THREAD_LOAD_LOADED:
		var packed_scene = ResourceLoader.load_threaded_get("res://scenes/game.tscn")
		get_tree().change_scene_to_packed(packed_scene)


func _on_back_ground_change_timer_timeout() -> void:
	var random = randi_range(0,10)
	if random == 0:
		background.frame = 0
	elif random == 1:
		for x in range(5):
			background.frame = 1
			await get_tree().create_timer(0.2).timeout
			background.frame = 0
	elif random == 2:
		for x in range(5):
			background.frame = 2
			await get_tree().create_timer(0.2).timeout
			background.frame = 0
	$BackGroundChange_Timer.wait_time = randf_range(0.1, 0.4)
	$BackGroundChange_Timer.start()


func _on_static_timer_timeout() -> void:
	$Static.self_modulate.a = randf_range(0.4,0.6)
	background.self_modulate.a = randf_range(0.8,1)


func _on_settings_pressed() -> void:
	$Static.self_modulate.a = 1000
	$ColorRect2.self_modulate.a = 1000
	$StaticTimer.stop()
	show_and_hide($Settings, $Menu)
	$Menu/ClickSound.play()


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


func _on_exit_pressed() -> void:
	$StaticTimer.start()
	$Menu/ClickSound.play()
	show_and_hide($Menu, $Settings)
	$ColorRect2.self_modulate.a = 0
	GlobalVars.volume[0] = db_to_linear(
		AudioServer.get_bus_volume_db(slider_volume_master.bus_index)
	)
	GlobalVars.volume[1] = db_to_linear(
		AudioServer.get_bus_volume_db(slider_volume_vfx.bus_index)
	)
	Saveload.contents_to_save.master_volume = GlobalVars.volume[0] 
	Saveload.contents_to_save.vfx_volume = GlobalVars.volume[1] 
	Saveload._save()



func _on_exit_mouse_entered() -> void:
	Saveload._save()
	$Menu/HoverSound.play()


func _on_play_mouse_entered() -> void:
	$Menu/HoverSound.play()
	$Menu/MenuButtons/ButtonBackgoundSprite.set_position(Vector2(132, 143))


func _on_options_mouse_entered() -> void:
	$Menu/HoverSound.play()
	$Menu/MenuButtons/ButtonBackgoundSprite.set_position(Vector2(125, 207))


func _on_quit_mouse_entered() -> void:
	$Menu/HoverSound.play()
	$Menu/MenuButtons/ButtonBackgoundSprite.set_position(Vector2(134, 267))


func _on_settings_mouse_entered() -> void:
	$Menu/HoverSound.play()
	$Menu/MenuButtons/ButtonBackgoundSprite.set_position(Vector2(125, 207))
