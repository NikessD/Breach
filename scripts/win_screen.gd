extends Control


func _ready() -> void:
	GlobalVars.config = ConfigFile.new()
	GlobalVars.config.save("res://save.cfg")
	$"Deep-strange-whoosh-183845".play()
	$CenterContainer/Night.text = "NIGHT " + str(GlobalVars.night_number)  

	
	
func _process(delta: float) -> void:
	pass



func _on_timer_timeout() -> void:
	get_tree().change_scene_to_file("res://scenes/menu.tscn")


func _on_timer_night_timeout() -> void:
	if GlobalVars.night < 6:
		GlobalVars.night += 1
	else:
		pass
	$CenterContainer/Night.text = "NIGHT " + str(GlobalVars.night) 
	GlobalVars.config.set_value("night number", "night", GlobalVars.night)
	GlobalVars.config.save("res://save.cfg")
