extends Control


func _ready() -> void:
	if GlobalVars.night < 6:
		GlobalVars.night += 1
	GlobalVars.config = ConfigFile.new()
	GlobalVars.config.save("res://save.cfg")
	GlobalVars.config.set_value("night number", "night", GlobalVars.night_number)
	GlobalVars.config.save("res://save.cfg")
	$"Deep-strange-whoosh-183845".play()
	$CenterContainer/Night.text = "SHIFT COMPLETED" 
	

func _on_timer_timeout() -> void:
	get_tree().change_scene_to_file("res://scenes/menu.tscn")
